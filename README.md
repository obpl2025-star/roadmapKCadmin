# Админка стажировки

1. Supabase → SQL Editor → выполните `schema_admin.sql` (после основного `schema.sql`).
2. Authentication → Users → Add user: email + пароль (Auto Confirm User). Затем в SQL Editor выполните последнюю закомментированную строку из `schema_admin.sql` со своим email.
3. Впишите Project URL и anon key в `config.js`.
4. Загрузите папку в НОВЫЙ репозиторий GitHub и включите Settings → Pages (main, root).
5. Обновите на основном сайте файл `sync.js` (он теперь записывает, кто зашёл) и перезалейте.

Доступ защищён логином и правилами RLS: без записи в таблице `admins` данные других людей не отдаются.
