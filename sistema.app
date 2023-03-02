
{application, sistema, [
  {description, "Descripcion de la app..."},
  {vsn, "1.1"},
  {modules,      [cliente,logica,server,supervisor_pro,sistema, database, servidor_DB]},
  {registered, [servidor_DB, server]},
  {applications, [kernel,stdlib, mnesia]},
  {mod, {sistema, []}}, %% Entrada a la app
  {env, []}
]}.