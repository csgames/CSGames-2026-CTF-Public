# Solution FR

En analysant le programme, on peut découvrir qu'il a été compilé avec GnuCOBOL. La documentation des fonctions est disponible en ligne, ce qui permet de récupérer certains éléments imporants, comme les structures `cob_field`.

``` C
struct cob_field
{
    size_t size;
    unsigned __int8 *data;
    unsigned __int8 *attr;
};
```

À mesure que l'on analyse le programme et qu'on assigne les structures `cob_field` au bon endroit, on peut comprendre que le programme lit le contenu du fichier `/root/flag.txt` et lui applique une modification, puis écrase le fichier avec le contenu modifié. Les détails de la modification sont disponible dans `solution.py`.

Noter que la variable `key_char2` de `solution.py` applique un `+ 1` additionnel puisque l'indexation commence à 1, mais le second shift (décalé de 16) n'est pas ajusté contre ceci, contrairement au premier shift, comme on peut l'observer dans la décompilation.

De plus, le programme COBOL décrémente les résultats des deux shifts par 1 supplémentaire, mais la solution python ne le fait pas. Il en est ainsi puisque COBOL index à partir de 1, et donc décale toutes les valeurs ASCII de 1. Voir cette documentation: https://www.ibm.com/docs/en/cobol-zos/6.3.0?topic=functions-ord

Voir i64/malbol.i64 pour ma solution plus détaillée (utiliser ida free 9.2)

# Solution EN

By analyzing the program, we can determine that it was compiled with GnuCOBOL. The function documentation is available online, which makes it possible to recover certain important elements, such as the cob_field structures.

``` C
struct cob_field
{
    size_t size;
    unsigned __int8 *data;
    unsigned __int8 *attr;
};
```

As the program is analyzed and the `cob_field` structures are assigned to the correct locations, we can understand that the program reads the contents of the file `/root/flag.txt`, applies a modification to it, and then overwrites the file with the modified content. The details of the modification are available in `solution.py`.

Note that the variable `key_char2` in `solution.py` applies an additional `+ 1` because indexing starts at 1, but the second shift (shifted by 16) is not adjusted for this, unlike the first shift, as can be observed in the decompilation.

Additionally, the COBOL program decrements the results of both shifts by an extra 1, but the Python solution does not do this. This is because COBOL indexes starting from 1 and therefore shifts all ASCII values by 1. See this documentation: https://www.ibm.com/docs/en/cobol-zos/6.3.0?topic=functions-ord

See `i64/malbol.i64` for my more detailed solution (use IDA Free 9.2).