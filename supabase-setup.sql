-- ═══════════════════════════════════════════
-- IEFI Photographer Website — Supabase Setup
-- انسخ الكود ده كله وشغّله في Supabase SQL Editor
-- ═══════════════════════════════════════════

-- 1. جدول الأعمال (Portfolio)
create table if not exists portfolio (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  image_url text not null,
  category text default 'عام',
  display_order int default 0,
  created_at timestamp with time zone default now()
);

-- 2. جدول الباقات (Packages)
create table if not exists packages (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text,
  price numeric not null default 0,
  features text[] default '{}',
  is_featured boolean default false,
  display_order int default 0,
  created_at timestamp with time zone default now()
);

-- 3. جدول الرسايل (Messages)
create table if not exists messages (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  email text not null,
  phone text,
  message text not null,
  is_read boolean default false,
  created_at timestamp with time zone default now()
);

-- 4. جدول الإعدادات (Settings)
create table if not exists settings (
  key text primary key,
  value text
);

-- 5. إعدادات افتراضية
insert into settings (key, value) values
  ('photographer_name', 'Ahmed Ihab Photography'),
  ('tagline', 'لحظاتك تستحق أن تُخلَّد'),
  ('bio', 'مصور فوتوغرافي محترف متخصص في تصوير الأعراس والبورتريه والفعاليات. أؤمن أن كل لحظة تستحق أن تحكي قصتها بصورة تدوم للأبد.'),
  ('phone', '01012345678'),
  ('whatsapp', ''),
  ('email', 'info@example.com'),
  ('location', 'القاهرة، مصر'),
  ('instagram', ''),
  ('facebook', ''),
  ('behance', '')
on conflict (key) do nothing;

-- 6. Row Level Security (RLS) — مهم للأمان
alter table portfolio enable row level security;
alter table packages enable row level security;
alter table messages enable row level security;
alter table settings enable row level security;

-- السماح لأي حد يقرأ الأعمال والباقات والإعدادات
create policy "Public read portfolio" on portfolio for select using (true);
create policy "Public read packages" on packages for select using (true);
create policy "Public read settings" on settings for select using (true);

-- السماح لأي حد يبعت رسالة تواصل
create policy "Public insert messages" on messages for insert with check (true);

-- الأدمن بس يقدر يعدل كل حاجة
create policy "Admin all portfolio" on portfolio for all using (auth.role() = 'authenticated');
create policy "Admin all packages" on packages for all using (auth.role() = 'authenticated');
create policy "Admin all messages" on messages for all using (auth.role() = 'authenticated');
create policy "Admin all settings" on settings for all using (auth.role() = 'authenticated');

-- 7. Storage Bucket للصور
insert into storage.buckets (id, name, public) values ('images', 'images', true)
on conflict (id) do nothing;

-- سياسة رفع الصور للأدمن
create policy "Admin upload images" on storage.objects
  for insert with check (bucket_id = 'images' AND auth.role() = 'authenticated');

create policy "Public read images" on storage.objects
  for select using (bucket_id = 'images');

create policy "Admin delete images" on storage.objects
  for delete using (bucket_id = 'images' AND auth.role() = 'authenticated');

-- ✅ خلاص! الـ Database جاهز
