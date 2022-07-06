% una base de conocimientos en la que pueda representar
% recetas e ingredientes que poseo, y que pueda usar para
% consultar cosas como:
% - ¿Tengo lo necesario para hacer X receta? ¿Que ingredientes me faltan?
% - ¿Que recetas puedo hacer con los ingredientes que tengo?
% Parcialmente implementado / sin implementar:
% - ¿Qué recetas son veganas, vegeterianas, aptas celiaco?
% - ¿Cómo podría adaptar una receta para que sea una de las cosas mencionadas?
% - ¿Cuántos comen con una receta?
% - Si tengo que hacer comida para ciertas personas de quienes se sus
% restricciones alimenticias, ¿qué cosas puedo cocinar?

lleva(tortillaDePapas, papa, kilos(1)).
lleva(tortillaDePapas, cebolla, kilos(1/2)).
lleva(tortillaDePapas, aceite(oliva), ml(300)).
lleva(tortillaDePapas, sal, unaPizca).
lleva(tortillaDePapas, pimienta, unaPizca).
lleva(tortillaDePapas, harinaDeGarbanzo, kilos(0.2)).

lleva(tofuAlVerdeo, tofu, kilos(0.4)).
lleva(tofuAlVerdeo, leche(almendras), ml(150)).
lleva(tofuAlVerdeo, aceite(Aceite), ml(100)):-
    aceiteNeutro(Aceite).
lleva(tofuAlVerdeo, cebollaDeVerdeo, kilos(0.2)).
lleva(tofuAlVerdeo, mostazaDeDijon, cucharadaSopera).
lleva(tofuAlVerdeo, dienteDeAjo, cantidad(1)).
lleva(tofuAlVerdeo, vinoBlanco, ml(100)).
lleva(tofuAlVerdeo, caldoVegetal, ml(150)).
lleva(tofuAlVerdeo, maizena, kilos(0.05)).
lleva(tofuAlVerdeo, sal, aGusto).
lleva(tofuAlVerdeo, pimienta, aGusto).

aceiteNeutro(girasol).

veggie(queso).
veggie(Ingrediente):-
    vegano(Ingrediente).
veggie(Receta):-
    receta(Receta),
    forall(lleva(Receta, Ingrediente, _), veggie(Ingrediente)).

vegano(papa).
vegano(cebolla).
vegano(aceite(_)).
vegano(sal).
vegano(pimienta).
vegano(harinaDeGarbanzo).
vegano(tofu).
vegano(leche(almendras)).
vegano(cebollaDeVerdeo).
vegano(mostazaDeDijon).
vegano(dienteDeAjo).
vegano(vinoBlanco).
vegano(caldoVegetal).
vegano(maizena).
vegano(Receta):-
    receta(Receta),
    forall(lleva(Receta, Ingrediente, _), vegano(Ingrediente)).

receta(Receta):-
    distinct(Receta, lleva(Receta, _, _)).

faltan(Receta, IngredientesFaltantes):-
    receta(Receta),
    findall((Ingrediente, CantidadFaltante),
            falta(Receta, Ingrediente, CantidadFaltante),
            IngredientesFaltantes).

falta(Receta, Ingrediente, CantidadFaltante):-
    lleva(Receta, Ingrediente, CantidadRequerida),
    hay(Ingrediente, CantidadQueHay),
    faltaIngrediente(CantidadQueHay, CantidadRequerida, CantidadFaltante).
falta(Receta, Ingrediente, CantidadRequerida):-
    lleva(Receta, Ingrediente, CantidadRequerida),
    not(hay(Ingrediente, _)).

sePuedeCocinar(Receta):-
    receta(Receta),
    not(falta(Receta, _, _)).

faltaParaLlegar(X, Y, Z):-
    number(X),
    number(Y),
    Y > X,
    Z is Y - X.

faltaIngrediente(kilos(X), kilos(Y), kilos(Z)):- faltaParaLlegar(X, Y, Z).
faltaIngrediente(ml(X), ml(Y), ml(Z)):- faltaParaLlegar(X, Y, Z).
faltaIngrediente(cantidad(X), cantidad(Y), cantidad(Z)):- faltaParaLlegar(X, Y, Z).
faltaIngrediente(ml(X), cucharadaSopera, ml(Z)):-
    faltaIngrediente(ml(X), ml(10), ml(Z)).

hay(cebolla, mucha).
hay(pimienta, mucha).
hay(sal, mucha).
hay(aceite(oliva), mucha).
hay(papa, mucha).
hay(vinoBlanco, ml(90)).
hay(tofu, kilos(0.35)).
