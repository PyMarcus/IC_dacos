package configs

const (
	DB_CONNECTION string = "user:@(127.0.0.1:3306)/banco?charset=utf8mb4,utf8\0026readTimeout=30s&parseTime=true"
	SQL           string = "SELECT sample.path_to_file AS path, sample.project_name AS project, sample.has_smell, a.is_smell FROM sample LEFT JOIN annotation AS a ON sample.id = a.sample_id WHERE a.is_smell = 1 AND sample.has_smell = 1 AND sample.path_to_file not like '%Test%' AND sample.path_to_file not like '%test%';"
	BASE_PATH     string = "C:/IC/badsmells/code"
	DEST_PATH     string = "C:/IC/badsmells/code/smells"
)
