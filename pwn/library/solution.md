
# Solution FR

En analysant le programme et en l'utilisant, on peut comprendre qu'il est possible de réserver les livres de la bibliothèque et qu'un livre interdit se trouve, par défaut, parmis les livres réservés, mais qu'il n'est pas possible de l'observer. Ce livre interdit est le flag.

Toutefois, un problème du programme est qu'il manque un livre pour combler la liste de livres (de taille 10, si on se base sur les checks dans les `if`). Ceci n'aurait normalement pas d'impact puisque le livre numéro 9 ne peut pas être réservé de toute manière. En effet, si le livre de la bibliothèque à l'indice demandé (9 dans ce cas) est `NULL`, alors le id du chunk dans le tas des livres empruntés est mis à -1.

Le problème est que l'attribut indiquant si le livre est emprunté ou non n'est pas réinitialisé, lui. Ainsi, il est possible de remplir le tas des livres empruntés avec des livres "fantômes" (numéro 9), ce qui aura pour effet de placer le curseur du tas sur le livre interdit (le flag). Normalement on serait bloqué à ce moment puisque le programme indiquerait qu'on ne peut emprunter plus de livres et qu'on doit en retourner, mais si on a pris soin d'emprunter et retourner un livre (parmis ceux permis) alors qu'on remplissait le tas, il resterait alors une case disponible dans le tas. 

À ce moment, il est alors possible de réserver le livre numéro 9 une dernière fois pour changer l'attribut "emprunté" du livre interdit à 1. Le id sera mis à -1, mais ce n'est pas important puisqu'il est maintenant possible de consulter le titre du livre interdit en affichant les livres empruntés, étant donné que la fonction qui affiche les livres empruntés ne vérifie pas le id du livre (seulement le titre et l'état du livre).

Pour la solution procédurale, voir `solution.py`

# Solution EN

By analyzing the program and using it, you can understand that it is possible to reserve books from the library and that, by default, a forbidden book is present among the reserved books, but it is not possible to view it. This forbidden book is the flag.

However, the program has a flaw: it lacks one book to completely fill the list of books (which has a size of 10, based on the checks in the `if` statements). Normally this would have no impact, since book number 9 cannot be reserved anyway. Indeed, if the book at the requested index in the library (9 in this case) is `NULL`, then the chunk ID in the borrowed books heap is set to -1.

The actual problem is that the attribute indicating whether the book is borrowed or not is not reset in this situation. Thus, if one fills the heap of reserved books with "ghost" books (number 9), the cursor in the borrowed books heap ends up pointing to the forbidden book (the flag). Normally, we would be blocked at that stage since the program would simply tell us that we have borrowed the maximum amount of books and that we should now return some of them, but if we were careful enough to borrow and return a book (among the ones we are allowed to borrow) while we were filling the heap, then there would still be a free spot.

At that moment, one must simply reserve book number 9 one more time, as this operation will change the “borrowed” attribute of the forbidden book to 1. The ID will be set to -1, but this is irrelevant because it then becomes possible to read the title of the forbidden book by displaying the list of borrowed books — since the function that displays borrowed books does not check the ID of the book (it only checks the title and the borrowed status).

For the procedural solution, see `solution.py`.

