-- Supabase -> SQL Editor. Выполнить ПОСЛЕ schema.sql

-- Кто заходил на платформу
create table if not exists public.profiles (
  user_id    uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  full_name  text,
  first_seen timestamptz not null default now(),
  last_seen  timestamptz not null default now()
);
alter table public.profiles enable row level security;
create policy "own profile select" on public.profiles for select to authenticated using (auth.uid() = user_id);
create policy "own profile insert" on public.profiles for insert to authenticated with check (auth.uid() = user_id);
create policy "own profile update" on public.profiles for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Администраторы
create table if not exists public.admins (user_id uuid primary key references auth.users(id) on delete cascade);
alter table public.admins enable row level security;
create policy "admin sees self" on public.admins for select to authenticated using (auth.uid() = user_id);

create or replace function public.is_admin() returns boolean
language sql security definer stable set search_path = public
as $$ select exists (select 1 from public.admins where user_id = auth.uid()) $$;

create policy "admin read profiles" on public.profiles for select to authenticated using (public.is_admin());
create policy "admin read progress" on public.progress for select to authenticated using (public.is_admin());

-- Назначить админа: сначала создайте пользователя в Authentication -> Users -> Add user (email + пароль, Auto Confirm),
-- затем подставьте его email:
-- insert into public.admins (user_id) select id from auth.users where email = 'ВАШ_EMAIL';
