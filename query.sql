show databases;

use tagman5;
use `tagman-extended`; -- tabelas mais populadas

show tables;

-- tabelas
select * from method_metrics; 	-- id, cc, loc, pc, method_name, package_name, project_name, type_name
select * from class_metrics; 	-- id, dit, fanin, fanout, lcom, loc, nc, nof, nom, nopf, nopm, wmc, package_name, project_name, type_name
select * from sample; 			-- id, designite_id, has_smell, is_class, path_to_file, project_name, sample_constraints, smells
select * from annotation;		-- id, iscm, isim, islp, isma, is_smell, sample_id
select * from smell;  			-- vazia, mas, conteria nome dos smells, se são ou não design ou se há descrição .



/*IDENTIFICAÇÃO DE QUAL REPOSITORIO/PACOTE TEM MAIS SMELLS COM > 13 LINHAS DE CODIGO E cc = 30 (MUITO RUINS) */
SELECT
    sample.path_to_file AS path,
    sample.project_name AS project,
    cm.package_name AS package,
    mm.method_name AS method,
    mm.cc AS complexity,
    cm.type_name AS type,
    cm.loc AS line_of_code,
    CASE
        WHEN sample.has_smell = 1 THEN 'yes'
        WHEN sample.has_smell = 0 THEN 'not'
    END AS smell,
    CASE
        WHEN sample.is_class = 1 THEN 'yes'
        WHEN sample.is_class = 0 THEN 'not'
    END AS class
FROM
    sample
    JOIN class_metrics AS cm ON cm.project_name = sample.project_name
    JOIN method_metrics AS mm ON mm.project_name = cm.project_name
WHERE
    cm.loc > 13
    AND mm.loc > 13
    AND mm.cc = 30
    AND sample.has_smell = 1;


/*PROJETO COM MAIS SMELLS*/
SELECT
    sample.path_to_file AS path,
    sample.project_name AS project,
    count(sample.project_name) as total_smells
FROM
    sample
WHERE
    sample.has_smell = 1 and sample.project_name not like '%Test%'
GROUP BY 
	sample.project_name
order by total_smells desc;


/*CODIGOS COM SMELLS QUE NAO SEJAM TEST*/
SELECT
    *
FROM
    sample
    JOIN method_metrics AS mm ON mm.project_name = sample.project_name
WHERE
    sample.has_smell = 1 and sample.project_name not like '%Test%' and sample.project_name like 'MovingBlocks_Terasology';



/*PROJETO COM MAIS SMELLS , MÉTODOS E MAIOR QNT DE LINHAS DE CODIGO*/
SELECT
    sample.path_to_file AS path,
    sample.project_name AS project,
    mm.method_name AS method,
    cm.type_name AS type,
    cm.loc as lines_of_code
FROM
    sample
    JOIN method_metrics AS mm ON mm.project_name = sample.project_name
    JOIN class_metrics AS cm ON cm.project_name = sample.project_name
WHERE
    sample.project_name like 'MovingBlocks_Terasology'
order by cm.loc desc limit 1;
    
    
    
/*CODIGOS COM SMELLS*/
SELECT
    sample.path_to_file AS path,
    sample.project_name AS project,
    cm.package_name AS package,
    mm.method_name AS method
FROM
    sample
    JOIN class_metrics AS cm ON cm.project_name = sample.project_name and sample.has_smell = 1
    JOIN method_metrics AS mm ON mm.project_name = cm.project_name;
