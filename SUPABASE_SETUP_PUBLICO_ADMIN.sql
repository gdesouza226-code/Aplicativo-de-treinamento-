-- SHOPPING D - Portal de Treinamentos
-- VERSÃO PÚBLICA PARA CONSULTA + ÁREA ADMINISTRATIVA PARA EDIÇÃO
-- Execute UMA VEZ no Supabase > SQL Editor.
-- Não apaga usuários, não apaga treinamentos e não apaga arquivos.

create table if not exists public.trainings (
  id text primary key,
  title text not null,
  training_date date not null,
  instructor text,
  location text,
  category text,
  status text,
  objective text,
  context text,
  participants jsonb not null default '[]'::jsonb,
  photos jsonb not null default '[]'::jsonb,
  materials jsonb not null default '[]'::jsonb,
  positive text,
  negative text,
  improvement text,
  conclusion text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.training_models (
  id text primary key,
  title text not null,
  category text,
  description text,
  files jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now()
);

alter table public.trainings enable row level security;
alter table public.training_models enable row level security;

-- TRAININGS
drop policy if exists "Portal trainings read" on public.trainings;
drop policy if exists "Portal trainings insert" on public.trainings;
drop policy if exists "Portal trainings update" on public.trainings;
drop policy if exists "Portal trainings delete" on public.trainings;
drop policy if exists "Authenticated trainings read" on public.trainings;
drop policy if exists "Authenticated trainings insert" on public.trainings;
drop policy if exists "Authenticated trainings update" on public.trainings;
drop policy if exists "Authenticated trainings delete" on public.trainings;
drop policy if exists "Public trainings read" on public.trainings;

create policy "Public trainings read"
on public.trainings for select
to anon, authenticated
using (true);

create policy "Authenticated trainings insert"
on public.trainings for insert
to authenticated
with check (true);

create policy "Authenticated trainings update"
on public.trainings for update
to authenticated
using (true)
with check (true);

create policy "Authenticated trainings delete"
on public.trainings for delete
to authenticated
using (true);

-- MODELOS
drop policy if exists "Portal models read" on public.training_models;
drop policy if exists "Portal models insert" on public.training_models;
drop policy if exists "Portal models update" on public.training_models;
drop policy if exists "Portal models delete" on public.training_models;
drop policy if exists "Authenticated models read" on public.training_models;
drop policy if exists "Authenticated models insert" on public.training_models;
drop policy if exists "Authenticated models update" on public.training_models;
drop policy if exists "Authenticated models delete" on public.training_models;
drop policy if exists "Public models read" on public.training_models;

create policy "Public models read"
on public.training_models for select
to anon, authenticated
using (true);

create policy "Authenticated models insert"
on public.training_models for insert
to authenticated
with check (true);

create policy "Authenticated models update"
on public.training_models for update
to authenticated
using (true)
with check (true);

create policy "Authenticated models delete"
on public.training_models for delete
to authenticated
using (true);

-- STORAGE permanece PRIVADO.
insert into storage.buckets (id,name,public,file_size_limit)
values ('training-files','training-files',false,104857600)
on conflict (id) do update
set public=false,file_size_limit=104857600;

drop policy if exists "Portal storage read" on storage.objects;
drop policy if exists "Portal storage insert" on storage.objects;
drop policy if exists "Portal storage update" on storage.objects;
drop policy if exists "Portal storage delete" on storage.objects;
drop policy if exists "Authenticated storage read" on storage.objects;
drop policy if exists "Authenticated storage insert" on storage.objects;
drop policy if exists "Authenticated storage update" on storage.objects;
drop policy if exists "Authenticated storage delete" on storage.objects;
drop policy if exists "Public storage read" on storage.objects;

-- Visitantes podem somente LER arquivos existentes através de URL assinada.
create policy "Public storage read"
on storage.objects for select
to anon, authenticated
using (bucket_id='training-files');

-- Somente usuário autenticado pode enviar, alterar ou excluir.
create policy "Authenticated storage insert"
on storage.objects for insert
to authenticated
with check (bucket_id='training-files');

create policy "Authenticated storage update"
on storage.objects for update
to authenticated
using (bucket_id='training-files')
with check (bucket_id='training-files');

create policy "Authenticated storage delete"
on storage.objects for delete
to authenticated
using (bucket_id='training-files');
