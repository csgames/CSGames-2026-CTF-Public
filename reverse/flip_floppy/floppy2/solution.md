# Solution FR 

Après avoir expérimenté avec le programme, on peut deviner que le flag se trouve dans les nourritures que le serpent peut manger. On peut alors utiliser gdb et et avancer "step by step" (`si`) jusqu'à ce qu'on tombe sur la fonction qui ajoute les nourritures pour essayer d'en comprendre le fonctionnement. Il est alors possible de trouver d'où vient le symbole utilisé pour la nourriture et ainsi retrouver le flag.

À l'adresse `0x7D67`, le programme récupère une liste d'indices (se trouvant à `0x7C08`) qu'il utilise ensuite pour récupérer les lettres du flag. La ressource en ligne https://wiki.osdev.org est une bonne source d'information pour les bootloaders et aide grandement à interpréter le comportement du programme.

Lorsqu'on réalise qu'on a affaire à un bootloader, on peut trouver que celui-ci s'exécute en "real mode". On peut ainsi choisir le bon format d'instructions pour Ghidra (IDA Free 9.2 le trouve automatiquement si on choisi le mode 16-bit). Il est aussi possible de sélectionner 0000:7c00 comme adresse de base (base address) étant donné qu'on sait que le bootloader est chargé à cette addresse.

Comme Ghidra ne désassemble pas automatiquement le programme, on peut le forcer avec la touche `d` lorsque le curseur se trouve à l'endroit où l'on appliquer le désassemblage. On observe ainsi que la première instruction est un jump, sautant ainsi par dessus les premiers bytes, qui sont du data (ce qu'on peut confirmer en analysant le code désassemblé).

Le fichier `solution.py` montre comment récupérer le flag.

# Solution EN

After experimenting with the program, one can infer that the flag is located within the food items that the snake can consume. It is then possible to use GDB and proceed step by step (`si`) until reaching the function responsible for adding the food items, in order to understand its operation. This approach allows for identifying the origin of the symbol used for the food and thereby recovering the flag.

At the address `0x7D67`, the program retrieves a list of indices (located at `0x7C08`) that it subsequently uses to extract the letters of the flag. The online resource https://wiki.osdev.org serves as an excellent source of information on bootloaders and greatly assists in interpreting the program's behavior.

Upon realizing that the program is a bootloader, one can determine that it executes in "real mode." It is thus possible to select the appropriate instruction format for Ghidra (IDA Free 9.2 detects it automatically if the 16-bit mode is chosen). Additionally, one may select 0000:7c00 as the base address, given that the bootloader is known to be loaded at this location.

Since Ghidra does not disassemble the program automatically, disassembly can be forced by pressing the `d` key when the cursor is positioned at the desired location. It is observed that the first instruction is a jump, thereby skipping over the initial bytes, which consist of data (a fact that can be confirmed by analyzing the disassembled code).

The file solution.py demonstrates how to retrieve the flag.

# Exécuter le programme / Execute the program

```
$ qemu-system-i386 -drive format=raw,file=floppy2
```

# Débugger dans GDB / Debug in GDB

Server:
```
$ qemu-system-i386 -drive format=raw,file=floppy2 -S -s
```

> Les deux premières commandes peuvent être trouvées ici / The first two commands can be found here: https://stackoverflow.com/questions/32955887/how-to-disassemble-16-bit-x86-boot-sector-code-in-gdb-with-x-i-pc-it-gets-tr
> Elles permettent d'observer le code désassemblé dans GDB en mode 16-bit real mode / They allow you to see the disassembled code in 16-bit real mode in GDB.

Client:
```
$ echo '<?xml version="1.0"?><!DOCTYPE target SYSTEM "gdb-target.dtd"><target><architecture>i8086</architecture><xi:include href="i386-32bit.xml"/></target>' > target.xml
$ wget https://raw.githubusercontent.com/qemu/qemu/master/gdb-xml/i386-32bit.xml
$ gdb
(gdb) target remote :1234
(gdb) set architecture i8086
(gdb) set tdesc filename target.xml
(gdb) b *0x7c00
(gdb) c
```

