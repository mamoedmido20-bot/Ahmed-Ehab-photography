import { NextResponse, type NextRequest } from 'next/server'

export async function middleware(request: NextRequest) {
  // لو الـ env vars مش موجودة — ابعت الـ user للـ login بدون ما تكرش
  const supabaseUrl  = process.env.NEXT_PUBLIC_SUPABASE_URL
  const supabaseKey  = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY

  if (!supabaseUrl || !supabaseKey) {
    // لو بيحاول يدخل الأدمن من غير سيت أب — ابعته للـ login
    if (
      request.nextUrl.pathname.startsWith('/admin') &&
      !request.nextUrl.pathname.startsWith('/admin/login')
    ) {
      return NextResponse.redirect(new URL('/admin/login', request.url))
    }
    return NextResponse.next()
  }

  // ── Supabase auth check ─────────────────────────────────
  const { createServerClient } = await import('@supabase/ssr')
  let supabaseResponse = NextResponse.next({ request })

  const supabase = createServerClient(supabaseUrl, supabaseKey, {
    cookies: {
      getAll() { return request.cookies.getAll() },
      setAll(cookiesToSet) {
        cookiesToSet.forEach(({ name, value }) => request.cookies.set(name, value))
        supabaseResponse = NextResponse.next({ request })
        cookiesToSet.forEach(({ name, value, options }) =>
          supabaseResponse.cookies.set(name, value, options)
        )
      },
    },
  })

  const { data: { user } } = await supabase.auth.getUser()

  // حماية صفحات الأدمن
  if (
    request.nextUrl.pathname.startsWith('/admin') &&
    !request.nextUrl.pathname.startsWith('/admin/login')
  ) {
    if (!user) {
      return NextResponse.redirect(new URL('/admin/login', request.url))
    }
  }

  // لو مسجّل دخول مش محتاج يرجع لصفحة الـ login
  if (request.nextUrl.pathname === '/admin/login' && user) {
    return NextResponse.redirect(new URL('/admin', request.url))
  }

  return supabaseResponse
}

export const config = {
  matcher: ['/admin/:path*'],
}
