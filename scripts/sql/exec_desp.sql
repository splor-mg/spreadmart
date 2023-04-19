create view exec_desp as
select f.ano_particao as ano, 
       dm_unidade_or.cd_unidade_orc as uo_cod,
       dm_categ_econ.cd_categ_econ as categoria_cod,
       dm_categ_econ.nome as categoria_desc,
       dm_grupo_desp.cd_grupo as grupo_cod,
       dm_grupo_desp.nome as grupo_desc,
       dm_modalidade_apli.cd_modalidade_aplic as modalidade_cod,
       dm_modalidade_apli.nome as modalidade_desc,
       dm_elemento_desp.cd_elemento as elemento_cod,
       dm_elemento_desp.nome as elemento_desc,
       dm_item_desp.cd_item as item_cod,
       dm_item_desp.nome as item_desc,
       sum(f.vr_empenhado) as vl_emp
from ft_despesa f 
join dm_unidade_or on dm_unidade_or.id_unidade_orc = f.id_unidade_orc 
join dm_categ_econ on dm_categ_econ.id_categ_econ = f.id_categ_econ 
join dm_grupo_desp on dm_grupo_desp.id_grupo = f.id_grupo 
join dm_modalidade_apli on dm_modalidade_apli.id_modalidade_aplic = f.id_modalidade_aplic 
join dm_elemento_desp on dm_elemento_desp.id_elemento = f.id_elemento 
join dm_item_desp on dm_item_desp.id_item = f.id_item 
group by f.ano_particao,
         dm_unidade_or.cd_unidade_orc,
         dm_categ_econ.cd_categ_econ,
         dm_categ_econ.nome,
         dm_grupo_desp.cd_grupo,
         dm_grupo_desp.nome,
         dm_modalidade_apli.cd_modalidade_aplic,
         dm_modalidade_apli.nome,
         dm_elemento_desp.cd_elemento,
         dm_elemento_desp.nome,
         dm_item_desp.cd_item,
         dm_item_desp.nome
