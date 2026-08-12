# 📸 موقع المصور الفوتوغرافي

موقع احترافي كامل مع Admin Panel — مبني بـ Next.js + Supabase

## 🚀 خطوات الإعداد (5 خطوات بس!)

### الخطوة 1 — إنشاء حساب Supabase (مجاني)
1. اتفضل على supabase.com وسجل
2. اضغط "New Project" وانتظر دقيقة

### الخطوة 2 — إعداد الـ Database
1. في Supabase Dashboard، اضغط "SQL Editor"
2. افتح ملف `supabase-setup.sql` من المشروع
3. انسخ كل المحتوى والصقه واضغط "Run" ✅

### الخطوة 3 — إنشاء حساب الأدمن
1. في Supabase → Authentication → Users
2. اضغط "Add User" وادخل إيميل وباسوورد

### الخطوة 4 — ملف .env.local
انسخ `.env.local.example` لـ `.env.local` وأضف:
```
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...
SUPABASE_SERVICE_ROLE_KEY=eyJ...
```
الـ Keys موجودة في: Supabase → Project Settings → API

### الخطوة 5 — تشغيل المشروع
```bash
npm install
npm run dev
```
افتح http://localhost:3000 🎉

## 🌐 Deploy على Vercel (مجاني)
1. ارفع المشروع على GitHub
2. اتفضل على vercel.com وسجل بحساب GitHub
3. اضغط "New Project" واختار الـ Repository
4. في "Environment Variables"، أضف نفس الـ .env.local
5. اضغط Deploy 🚀

## 📋 صفحات الموقع
- `/` — الصفحة الرئيسية
- `/admin` — Dashboard (محمي)
- `/admin/portfolio` — إدارة الأعمال
- `/admin/packages` — إدارة الباقات
- `/admin/messages` — استقبال الرسايل
- `/admin/settings` — إعدادات الموقع
