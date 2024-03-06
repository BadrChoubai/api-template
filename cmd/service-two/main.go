package main

import (
	"context"
	"fmt"
	"io"
	"log"
	"os"
	"os/signal"
)

type application struct {
	serviceName string

	errorLog *log.Logger
	infoLog  *log.Logger
}

func run(
	ctx context.Context,
	getEnv func(string) (string, bool),
	stdout, stderr io.Writer,
) error {
	var serviceName string

	ctx, cancel := signal.NotifyContext(ctx, os.Interrupt)
	defer cancel()

	infoLog := log.New(stdout, "Info\t", log.Ldate|log.Ltime|log.Lshortfile)
	errorLog := log.New(stderr, "Error\t", log.Ldate|log.Ltime|log.Lshortfile)

	if value, ok := getEnv("SERVICE_NAME"); !ok {
		errorLog.Print("SERVICE_NAME not set")
		os.Exit(1)
	} else {
		serviceName = value
	}

	app := &application{
		serviceName: serviceName,
		infoLog:     infoLog,
		errorLog:    errorLog,
	}

	app.infoLog.Printf("Service: %s starting...", app.serviceName)

	return nil
}

func main() {
	ctx := context.Background()

	if err := run(ctx, os.LookupEnv, os.Stdout, os.Stderr); err != nil {
		fmt.Fprintf(os.Stderr, "%s\n", err)
		os.Exit(1)
	}
}
