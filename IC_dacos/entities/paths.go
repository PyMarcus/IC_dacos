package entities

type Paths struct {
	Path     string `db:"path"`
	Project  string `db:"project"`
	HasSmell string `db:"has_smell"`
	IsSmell  string `db:"is_smell"`
}
