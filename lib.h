#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

typedef struct cell data;


/**** Functions ****/

char *toString(char *old);

void printOp(float value);

void printVar(data *data);

void printVars(data *data);

data *returnLast(data *data);

data *find(data *data, char *id);

int contains(data *data, char *id);

void attrChar(data *data, char *id, char *value);

void attrNum(data *data, char *id, float value);

void add(data *data, char *type, char *id);

char getCharValue(data *data, char *id);

float getNumValue(data *data, char *id);

int getCharIntValue(char* value);



int TAM = 0;

struct cell {
    char *type;
    char *id;
    char charValue;
    int intValue;
    float floatValue;
    struct cell *next;
};

void add(data *data, char *type, char *id) {

    if ((TAM != 0) && (contains(data, id) == 1)) {
        printf("Variável de identificador %s já foi declarada! \n", id);
        exit(1);
    }

    if (TAM == 0) {
        data->id = id;
        data->type = type;
        printVar(data);
    } else {
        struct cell *n = malloc(sizeof(struct cell));
        n->type = type;
        n->id = id;
        n->next = NULL;
        struct cell *last = returnLast(data);
        last->next = n;
        printVar(n);
    }
    TAM += 1;
}

data *returnLast(data *data) {
    struct cell *u = data->next;
    if (u == NULL) {
        return data;
    }
    while (u->next != NULL) {
        u = u->next;
    }
    return u;
}

void printVars(data *data) {
    struct cell *u = data;
    printf("*********************** \n"
           " Variáveis Declaradas"
           " \n*********************** \n");
    while (u != NULL) {

        if (u->type != NULL) {
            if (!strcmp(u->type, "char")) {
                printf("var = {type: %s, id: %s, value: %c}\n", u->type, u->id, u->charValue);
            } else if (!strcmp(u->type, "float")) {
                printf("var = {type: %s, id: %s, value: %f}\n", u->type, u->id, u->floatValue);
            } else {
                printf("var = {type: %s, id: %s, value: %d}\n", u->type, u->id, u->intValue);
            }
        }
        u = u->next;
    }
    printf("Total de variáveis declaradas: %d\n", TAM);
}

void printVar(data *data) {
    if (!strcmp(data->type, "char")) {
        printf("var = {type: %s, id: %s, value: %c}\n", data->type, data->id, data->charValue);
    } else if (!strcmp(data->type, "float")) {
        printf("var = {type: %s, id: %s, value: %f}\n", data->type, data->id, data->floatValue);
    } else {
        printf("var = {type: %s, id: %s, value: %d}\n", data->type, data->id, data->intValue);
    }
}

int contains(data *data, char *id) {
    struct cell *u = data;

    while (u != NULL && u->id != NULL) {
        if (strcmp(u->id, id) == 0) {
            return 1;
        }
        u = u->next;
    }
    return 0;
}

data *find(data *data, char *id) {
    struct cell *u = data;

    while (u != NULL && u->id != NULL) {
        if (strcmp(u->id, id) == 0) {
            return u;
        }
        u = u->next;
    }
    return NULL;
}

void attrChar(data *data, char *id, char *value) {

    if (strlen(value) > 1) {
        printf("Expressão inválida, valor passado deve ser um char e não uma string! \n");
        exit(1);
    }

    if (contains(data, id) == 0) {
        printf("Variável de identificador %s não foi declarada! \n", id);
        exit(1);
    }

    struct cell *u = find(data, id);

    if (strcmp(u->type, "char")) {
        printf("Tipos incompatíveis, o id %s espera um valor do tipo %s! \n", u->id, u->type);
        exit(1);
    }


    u->charValue = value[0];

    printVar(u);

}

void attrNum(data *data, char *id, float value) {
    if (contains(data, id) == 0) {
        printf("Variável de identificador %s não foi declarada! \n", id);
        exit(1);
    }

    struct cell *u = find(data, id);

    if (!strcmp(u->type, "char")) {
        printf("Tipos incompatíveis, o id %s espera um valor do tipo %s! \n", u->id, u->type);
        exit(1);
    }

    if (!strcmp(u->type, "int")) {
        u->intValue = value;
    } else {
        u->floatValue = value;
    }

    printVar(u);

}

char getCharValue(data *data, char *id) {
    if (contains(data, id) == 0) {
        printf("Variável de identificador %s não foi declarada! \n", id);
        exit(1);
    }

    struct cell *u = find(data, id);
    return u->charValue;
}

float getNumValue(data *data, char *id) {
    if (contains(data, id) == 0) {
        printf("Variável de identificador %s não foi declarada! \n", id);
        exit(1);
    }

    struct cell *u = find(data, id);

    if (!strcmp(u->type, "int")) {
        return u->intValue;
    } else {
        return u->floatValue;
    }
}

/****  UTIL FUNCTIONS */

char *toString(char *old) {
    char *n = malloc((sizeof(char)) * strlen(old));
    strcpy(n, old);
    return n;
}

int getCharIntValue(char* value) {
    if (strlen(value) > 1) {
        printf("Expressão inválida, valor passado deve ser um char e não uma string! \n");
        exit(1);
    }

    return (int) value[0];
}

void printOp(float value) {
    if (round(value) == value) {
        printf("Resultado da operação: %d\n", (int) value);
    } else {
        printf("Resultado da operação: %f\n", value);
    }
}


