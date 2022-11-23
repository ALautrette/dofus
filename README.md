<h1>Lancement de l'app avec docker</h1>
Dans le répertoire : (Pour tout sauf W10)

```
docker run --rm \
    -u "$(id -u):$(id -g)" \
    -v $(pwd):/var/www/html \
    -w /var/www/html \
    laravelsail/php81-composer:latest \
    composer install --ignore-platform-reqs
```
Pour W10 : (nécessite php + composer)

```
composer update
```

Puis :

```
docker compose up
```




<h1> CAHIER DES CHARGES </h1> 

<h2> Développement d’une application web de création d’équipement pour le jeu Dofus </h2>


<h2> L’histoire de Dofus. </h2>

Dofus est un MMORPG français sorti en 2004 développé par Ankama game. Le jeu a connu un très grand succès dans ses premières années, malgré une perdition du nombre de joueur, une communauté solide reste présente sur le jeu. 

<h2> Contexte. </h2>

Avec la difficulté croissante du nouveau contenu ajouté au fil du temps, l’optimisation de son équipement devient primordiale. Cependant, cela peut s’avérer très difficile et chronophage, notamment dû au grand nombre d’équipements disponibles, et donc des combinaisons possibles.

<h2> Problématique. </h2>

Etant compliqué de récupérer tous les objets du jeu, il est difficilement d’optimisé sont équipement via le jeu.

Cela pose donc différentes problématiques aux joueurs :
-	Comment étudier un équipement sans devoir se procurer tous les objets ?
-	Comment comparer deux équipements facilement ?

<h2> Besoin. </h2>

	De l’étude des problématiques des joueurs, les besoins suivants ressortent :
 
-	Pouvoir créer un équipement en utilisant n’importe quels objets du jeu.
-	Pouvoir enregistrer ses équipements.
-	Pouvoir regarder les statistiques d’un équipement.
-	Pouvoir comparer les statistiques de plusieurs équipements. 

<h2> Contrainte. </h2>

-	La solution doit pouvoir être utilisable sur ordinateur ou mobile.
-	La solution doit être accessible depuis une interface web.
-	La solution doit être indépendante du jeu.

<h2> Livrable. </h2>

	2 livrables sont attendus :
•	La solution packagée dans des conteneurs type Docker
•	La documentation contenant les procédures d'installation et de déploiement, le guide utilisateur et le guide administrateur.

<h2> Solution Fonctionnelle. </h2>

-	Une interface intuitive permettant de sélectionner un ensemble d’objets pour former un équipement.
-	Un système d’archivage d’équipement créé par l’utilisateur.
-	Un système de comparaison claire de différent équipement.

<h2> Solution Technique. </h2>

-	Une base de données PostgreSQL pour la gestion et la manipulation des données. PostgreSQL est une base de données libre, sans coût de licence, et elle existe depuis plus de 20 ans.
-	Serveur Web Apache pour la délivrance des pages Web. Apache est aujourd'hui le serveur le plus populaire et dispose de nombreux modules.
-	PHP pour la génération dynamique de pages web. PHP est un Langage simple et rapide à mettre en œuvre pour la création de site web. Bibliothèques très fournies. 
Avec le framework Laravel, gratuit et facilitant le travail en php. Il est le plus populaire en PHP, avec une grande communauté.
-	Docker pour le packaging de l'application dans un environnement maîtrisée et cloisonné.

<h2> Livrable. </h2>

Le livrable est un environnement Docker contenant l'ensemble des services, base de données et IHMs. Le livrable pourra s'installer sur une machine GNU/Linux avec Docker et docker-compose installés.








<p align="center"><a href="https://laravel.com" target="_blank"><img src="https://raw.githubusercontent.com/laravel/art/master/logo-lockup/5%20SVG/2%20CMYK/1%20Full%20Color/laravel-logolockup-cmyk-red.svg" width="400" alt="Laravel Logo"></a></p>

<p align="center">
<a href="https://travis-ci.org/laravel/framework"><img src="https://travis-ci.org/laravel/framework.svg" alt="Build Status"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/dt/laravel/framework" alt="Total Downloads"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/v/laravel/framework" alt="Latest Stable Version"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/l/laravel/framework" alt="License"></a>
</p>

## About Laravel

Laravel is a web application framework with expressive, elegant syntax. We believe development must be an enjoyable and creative experience to be truly fulfilling. Laravel takes the pain out of development by easing common tasks used in many web projects, such as:

- [Simple, fast routing engine](https://laravel.com/docs/routing).
- [Powerful dependency injection container](https://laravel.com/docs/container).
- Multiple back-ends for [session](https://laravel.com/docs/session) and [cache](https://laravel.com/docs/cache) storage.
- Expressive, intuitive [database ORM](https://laravel.com/docs/eloquent).
- Database agnostic [schema migrations](https://laravel.com/docs/migrations).
- [Robust background job processing](https://laravel.com/docs/queues).
- [Real-time event broadcasting](https://laravel.com/docs/broadcasting).

Laravel is accessible, powerful, and provides tools required for large, robust applications.

## Learning Laravel

Laravel has the most extensive and thorough [documentation](https://laravel.com/docs) and video tutorial library of all modern web application frameworks, making it a breeze to get started with the framework.

You may also try the [Laravel Bootcamp](https://bootcamp.laravel.com), where you will be guided through building a modern Laravel application from scratch.

If you don't feel like reading, [Laracasts](https://laracasts.com) can help. Laracasts contains over 2000 video tutorials on a range of topics including Laravel, modern PHP, unit testing, and JavaScript. Boost your skills by digging into our comprehensive video library.

## Laravel Sponsors

We would like to extend our thanks to the following sponsors for funding Laravel development. If you are interested in becoming a sponsor, please visit the Laravel [Patreon page](https://patreon.com/taylorotwell).

### Premium Partners

- **[Vehikl](https://vehikl.com/)**
- **[Tighten Co.](https://tighten.co)**
- **[Kirschbaum Development Group](https://kirschbaumdevelopment.com)**
- **[64 Robots](https://64robots.com)**
- **[Cubet Techno Labs](https://cubettech.com)**
- **[Cyber-Duck](https://cyber-duck.co.uk)**
- **[Many](https://www.many.co.uk)**
- **[Webdock, Fast VPS Hosting](https://www.webdock.io/en)**
- **[DevSquad](https://devsquad.com)**
- **[Curotec](https://www.curotec.com/services/technologies/laravel/)**
- **[OP.GG](https://op.gg)**
- **[WebReinvent](https://webreinvent.com/?utm_source=laravel&utm_medium=github&utm_campaign=patreon-sponsors)**
- **[Lendio](https://lendio.com)**

## Contributing

Thank you for considering contributing to the Laravel framework! The contribution guide can be found in the [Laravel documentation](https://laravel.com/docs/contributions).

## Code of Conduct

In order to ensure that the Laravel community is welcoming to all, please review and abide by the [Code of Conduct](https://laravel.com/docs/contributions#code-of-conduct).

## Security Vulnerabilities

If you discover a security vulnerability within Laravel, please send an e-mail to Taylor Otwell via [taylor@laravel.com](mailto:taylor@laravel.com). All security vulnerabilities will be promptly addressed.

## License

The Laravel framework is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).
