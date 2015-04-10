---
title: Monoides
author: Pablo Baeyens, Mario Román
---

La clase `Monoid`
----------------

Las clases de tipos permiten generalizar el comportamiento de un conjunto de tipos
a partir de una interfaz común: la clase `Eq` incluye los tipos que permiten comparar
por igualdad, la clase `Ord` aquellos que admiten una relación de orden...

La clase [`Monoid`](http://hackage.haskell.org/package/base-4.7.0.2/docs/Data-Monoid.html)
permite agrupar aquellos tipos `T` que sean un monoide; es decir, que tengan una
operación binaria `<> :: T -> T -> T` tal que:

  1. Es **asociativa**: `(a <> b) <> c == a <> (b <> c)`.
     *Ejemplo*: La suma, aunque no la resta: $(3 - 2) - 1 \neq  3 - (2 - 1)$.
  2. Existe un **elemento neutro**: `a <> mempty == a == mempty <> a`.
     *Ejemplo*: $0$ con respecto de la suma. La exponenciación no tiene.

El ejemplo más sencillo de monoide es el tipo `()` con `a <> b = ()`.
Para empezar a utilizarlos, importamos el módulo que los define:

\begin{code}
import Data.Monoid
\end{code}

Además, este módulo define la función `mconcat :: [m] -> m` que se define:

~~~haskell
mconcat = foldr (<>) mempty
~~~

Esta nos permite reducir listas de monoides.

Algunos ejemplos de monoides son:

Listas: [a]
-----------

En este caso, `<> = (++)` y `mempty = []`. Podemos comprobarlo con algunos ejemplos:

~~~haskell
ghci> [1,2] ++ [3,4] ++ [5,6]
[1,2,3,4,5,6]
ghci> [1,2] <> [3,4] <> [5,6]
[1,2,3,4,5,6]
ghci> [1,2,3,4] <> mempty
[1,2,3,4]
~~~

`Sum` y `Product`
-----------------

Los tipos numéricos permiten dos operaciones binarias con las que forman un monoide:
la suma y el producto. Para diferenciarlos se definen, dado un tipo numérico `a`,
tipos que los envuelven:

- `Sum`:     `Sum a <> Sum b = Sum (a + b)` y `mempty = Sum 0`.
- `Product`: `Product a <> Product b = Product (a * b)` y `mempty = Product 1`.

Las funciones `getSum` y `getProduct` permiten extraer el número del tipo. De esta
forma podemos definir:

\begin{code}
suma, producto :: Num a => [a] -> a
suma     = getSum     . mconcat . map Sum
producto = getProduct . mconcat . map Product
\end{code}

Estas son equivalentes a las funciones `sum` y `product` incluidas en el `Prelude`.

`Endo`
------

`Endo a` envuelve endomorfismos sobre un tipo `a` (funciones `a -> a`) y define un
monoide:

 - `Endo f <> Endo g = Endo (f . g)`:  la composición.
 - `mempty = Endo id`:  la función identidad, `id x = x`.

Extraemos la función con `appEndo :: Endo a -> (a -> a)`.
Utilizando este monoide podemos componer una lista de funciones fácilmente:

\begin{code}
fs :: Num a => [Endo a]
fs = [Endo (*3), Endo (+2), Endo negate, Endo (37-)]

g :: Num a => a -> a
g = appEndo (mconcat fs)
\end{code}

De esta forma forma tenemos `g x = (negate (37 - x) + 2) * 3`.


Pares de monoides
-----------------

Dados dos monoides `a` y `b` , se define el monoide `(a,b)` con:

- `mempty = (mempty, mempty)`.
- `(a1,b1) <> (a2,b2) =  (a1 <> a2, b1 <> b2)`

En cada elemento del par se emplea la operación del tipo correspondiente. Este monoide
es útil para la mónada `Writer`. Puede extenderse a tuplas de un número arbitrario de
elementos.

Cosas que se podrían añadir:

- [ ] Foldable: simplificación con foldMap
- [ ] http://blog.sigfpe.com/2009/01/haskell-monoids-and-their-uses.html
- [ ] https://www.fpcomplete.com/user/mgsloan/monoids-tour
- [ ] http://www.reddit.com/r/haskell/comments/1yc2vg/opportunities_to_use_monoids/