-- Tabla donde se guarda todo el planner (cada fila es una "hoja" del planner)
create table if not exists public.docs (
  user_id uuid not null default auth.uid() references auth.users on delete cascade,
  key text not null,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (user_id, key)
);
alter table public.docs enable row level security;
drop policy if exists "solo mis hojas" on public.docs;
create policy "solo mis hojas" on public.docs for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Carpeta privada para fotos y audios
insert into storage.buckets (id, name, public) values ('planner', 'planner', false)
  on conflict (id) do nothing;
drop policy if exists "ver mis archivos" on storage.objects;
drop policy if exists "subir mis archivos" on storage.objects;
drop policy if exists "borrar mis archivos" on storage.objects;
create policy "ver mis archivos" on storage.objects for select
  using (bucket_id = 'planner' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "subir mis archivos" on storage.objects for insert
  with check (bucket_id = 'planner' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "borrar mis archivos" on storage.objects for delete
  using (bucket_id = 'planner' and (storage.foldername(name))[1] = auth.uid()::text);

grant select, insert, update, delete on public.docs to authenticated;
