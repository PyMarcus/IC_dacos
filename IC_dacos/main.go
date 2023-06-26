package main

import (
	"fmt"
	"github.com/PyMarcus/IC_dacos/configs"
	"github.com/PyMarcus/IC_dacos/entities"
	_ "github.com/go-sql-driver/mysql"
	"github.com/jmoiron/sqlx"
	"log"
	"os"
	"strings"
)

// conecta-se ao banco mysql
func getReaderConnection() (*sqlx.DB, error) {
	return sqlx.Connect("mysql", configs.DB_CONNECTION)
}

// obtem dados do banco, os caminhos do codigo
func getAll() {
	var paths []entities.Paths

	conn, err := getReaderConnection()

	if err != nil {
		log.Println("[ERROR] Fail to connect")
		log.Panicln(err)
	}
	defer conn.Close()

	log.Println("[+]Successfully connected")
	err = conn.Select(&paths, configs.SQL)
	if err != nil {
		log.Println("[ERROR] Fail to select")
		log.Panicln(err)
	}

	createLocalPaths(&paths)
}

// formata string para criar os caminhos com base no path base
func createLocalPaths(paths *[]entities.Paths) {
	var localPaths []string
	var destPaths []string

	for _, path := range *paths {
		localPaths = append(localPaths, strings.Replace(fmt.Sprintf("%s%s", configs.BASE_PATH, path.Path), "/", "\\", -1))
		destPaths = append(destPaths, strings.Replace(fmt.Sprintf("%s\\%s", configs.DEST_PATH, strings.Split(path.Path, "/")[len(strings.Split(path.Path, "/"))-1]), "/", "\\", -1))
	}
	log.Println("[+]Paths created!")
	moveCodes(localPaths, destPaths)

}

// envia os codigos para um diretório à parte, separando a amostra
func moveCodes(originPaths, destPaths []string) {
	log.Println("[+]Moving codes...")
	for i := 0; i < len(originPaths); i++ {
		err := os.Rename(originPaths[i], destPaths[i])
		if err != nil {
			log.Println(err)
		}
	}
	log.Println("\n[+]OK.")
}

func main() {
	getAll()
}
