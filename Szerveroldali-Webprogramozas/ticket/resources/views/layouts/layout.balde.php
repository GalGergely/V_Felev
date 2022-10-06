<!DOCTYPE html>
<html lang="hu">

<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Ticket | @yield('title')</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" integrity="sha512-9usAa10IRO0HhonpyAIVpjrylPvoDwiPUiKdWk5t3PyolY1cOd4DSE0Ga+ri4AuTroPR5aQvXU9xC6qOPnzFeg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>

<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid mx-5">
            <a class="navbar-brand" href="#">Ticket</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#main-navbar" aria-controls="main-navbar" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="main-navbar">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link" href="feladatok.html">Nyitott feladatok</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="lezart_feladatok.html">Lezárt feladatok</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="uj_feladat.html">Új feladat</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="felhasznalok.html">Felhasználók (ADMIN)</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="feladatok.html">Összes feladat (ADMIN)</a>
                    </li>
                </ul>
                <div class="d-flex">
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                        <li class="nav-item">
                            <a class="nav-link" href="#">Bejelentkezés</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">Regisztráció</a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>
    <div class="container-fluid px-5 my-3">
        <div class="d-flex">
            <h1 class="ps-3 me-auto">[Feladat tárgya] <span class="badge bg-danger">Azonnal</span></h1>
            <button class="btn btn-primary mx-1" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Szerkesztés">
                <i class="fa-solid fa-pen-to-square fa-fw fa-xl"></i>
            </button>
            <button class="btn btn-primary mx-1" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Felhasználók">
                <i class="fa-solid fa-users fa-fw fa-xl"></i>
            </button>
            <button class="btn btn-success mx-1" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Lezárás">
                <i class="fa-solid fa-check fa-fw fa-xl"></i>
            </button>
            <button class="btn btn-danger mx-1" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Törlés">
                <i class="fa-solid fa-trash fa-fw fa-xl"></i>
            </button>
        </div>
        <hr />
        <div class="card mb-3">
            <div class="card-header d-flex">
                <div class="me-auto"><span class="badge bg-secondary">#0</span> | <strong>Felhasználó 1</strong> | 2022. 02. 28. 10:12:23</div>
                <div></div>
            </div>
            <div class="card-body">
                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus tempus tortor orci, ut dignissim urna auctor in. Maecenas molestie fringilla odio, eget euismod magna feugiat a. Duis feugiat purus ultrices orci convallis scelerisque. Aenean ac enim quis mauris ullamcorper tincidunt at a nisl. Suspendisse sollicitudin elit nec nulla pharetra dapibus. Cras finibus lectus vitae pharetra lobortis. Mauris vehicula imperdiet magna a euismod. Nam lobortis a nulla sit amet aliquet. Curabitur nisi neque, interdum vitae dui nec, vulputate pretium nunc. Ut lacinia a arcu vitae imperdiet. Sed eget est ex. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Donec eu neque pulvinar, gravida magna quis, auctor mauris.</p>
                <p>Maecenas elementum quam eu efficitur feugiat. Integer dui augue, convallis sed nisi ac, luctus scelerisque mi. Nullam ut leo eu quam faucibus varius eu at elit. Duis cursus a urna nec fermentum. Fusce vitae dictum orci, lobortis porttitor odio. Nullam tortor risus, rhoncus sed commodo id, egestas a tellus. Pellentesque justo est, posuere vel dictum in, tempor eget nisl. Suspendisse dapibus iaculis justo, mollis hendrerit arcu fermentum vitae. Praesent sem sem, volutpat sit amet egestas a, iaculis ut mauris. Nullam vel eleifend lacus. Praesent quis erat ac mauris suscipit sollicitudin a at nibh. Nulla commodo diam vitae ex sagittis, a congue massa vulputate. Fusce ac accumsan nunc, in aliquam massa. Ut semper risus sit amet tortor ornare, euismod iaculis erat elementum. In congue ut dui eget molestie. Sed sit amet egestas est.</p>
                <p>Praesent egestas, libero eu pulvinar ullamcorper, nulla massa tempor tortor, a laoreet leo ipsum eget dolor. Vivamus gravida enim in eleifend volutpat. Fusce mollis enim dui, at interdum risus sollicitudin et. Nunc dapibus ultricies nibh quis fringilla. Integer luctus ipsum sem, ut hendrerit lacus ultricies tincidunt. Phasellus feugiat congue tempor. Nullam a lacus pellentesque, dictum sapien et, molestie lorem. Aliquam scelerisque ullamcorper lorem, et accumsan sem sodales in. Duis euismod a nibh ut faucibus.</p>
                <p>Nullam iaculis quis est ut sollicitudin. Donec venenatis, nulla nec dapibus faucibus, augue metus consectetur augue, et faucibus quam lectus ut erat. Etiam lacinia tortor vitae lobortis sollicitudin. Nunc mollis felis et tincidunt malesuada. Donec feugiat, orci quis rhoncus viverra, mauris justo malesuada purus, vel eleifend augue leo ac eros. Cras egestas sapien at urna sodales, at rhoncus justo volutpat. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Pellentesque euismod luctus tortor, ut pharetra nulla hendrerit eget. Cras rhoncus neque ut tellus tempor varius id sed nunc. Ut pretium ipsum ac arcu semper, in pellentesque tellus accumsan.</p>
                <p>Vestibulum sapien purus, lacinia a dui vitae, varius lacinia enim. Sed nisi ante, tristique vitae ante scelerisque, luctus placerat metus. Duis vitae leo sollicitudin, tincidunt erat at, tempor magna. Nullam placerat ante in imperdiet consequat. Aliquam ac sagittis tortor. Fusce sed eleifend est, vitae auctor eros. Praesent in felis ante. Duis elementum nibh purus, at malesuada nibh scelerisque quis. Vivamus quis eros elit. Ut hendrerit leo ac gravida rutrum. Nulla facilisi. Vivamus at velit mattis, vehicula eros a, tincidunt ligula. Ut sit amet auctor ante, eget ultrices ante. Maecenas hendrerit ex quis sodales imperdiet. </p>
            </div>
        </div>
        <div class="card mb-3">
            <div class="card-header d-flex">
                <div class="me-auto"><span class="badge bg-secondary">#1</span> | <strong>Felhasználó 3</strong> | 2022. 02. 28. 10:12:23</div>
                <div><a href="#"><i class="fa-solid fa-download"></i></a></div>
            </div>
            <div class="card-body">
                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus tempus tortor orci, ut dignissim urna auctor in. Maecenas molestie fringilla odio, eget euismod magna feugiat a. Duis feugiat purus ultrices orci convallis scelerisque. Aenean ac enim quis mauris ullamcorper tincidunt at a nisl. Suspendisse sollicitudin elit nec nulla pharetra dapibus. Cras finibus lectus vitae pharetra lobortis. Mauris vehicula imperdiet magna a euismod. Nam lobortis a nulla sit amet aliquet. Curabitur nisi neque, interdum vitae dui nec, vulputate pretium nunc. Ut lacinia a arcu vitae imperdiet. Sed eget est ex. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Donec eu neque pulvinar, gravida magna quis, auctor mauris.</p>
                <p>Maecenas elementum quam eu efficitur feugiat. Integer dui augue, convallis sed nisi ac, luctus scelerisque mi. Nullam ut leo eu quam faucibus varius eu at elit. Duis cursus a urna nec fermentum. Fusce vitae dictum orci, lobortis porttitor odio. Nullam tortor risus, rhoncus sed commodo id, egestas a tellus. Pellentesque justo est, posuere vel dictum in, tempor eget nisl. Suspendisse dapibus iaculis justo, mollis hendrerit arcu fermentum vitae. Praesent sem sem, volutpat sit amet egestas a, iaculis ut mauris. Nullam vel eleifend lacus. Praesent quis erat ac mauris suscipit sollicitudin a at nibh. Nulla commodo diam vitae ex sagittis, a congue massa vulputate. Fusce ac accumsan nunc, in aliquam massa. Ut semper risus sit amet tortor ornare, euismod iaculis erat elementum. In congue ut dui eget molestie. Sed sit amet egestas est.</p>
                <p>Praesent egestas, libero eu pulvinar ullamcorper, nulla massa tempor tortor, a laoreet leo ipsum eget dolor. Vivamus gravida enim in eleifend volutpat. Fusce mollis enim dui, at interdum risus sollicitudin et. Nunc dapibus ultricies nibh quis fringilla. Integer luctus ipsum sem, ut hendrerit lacus ultricies tincidunt. Phasellus feugiat congue tempor. Nullam a lacus pellentesque, dictum sapien et, molestie lorem. Aliquam scelerisque ullamcorper lorem, et accumsan sem sodales in. Duis euismod a nibh ut faucibus.</p>
                <p>Nullam iaculis quis est ut sollicitudin. Donec venenatis, nulla nec dapibus faucibus, augue metus consectetur augue, et faucibus quam lectus ut erat. Etiam lacinia tortor vitae lobortis sollicitudin. Nunc mollis felis et tincidunt malesuada. Donec feugiat, orci quis rhoncus viverra, mauris justo malesuada purus, vel eleifend augue leo ac eros. Cras egestas sapien at urna sodales, at rhoncus justo volutpat. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Pellentesque euismod luctus tortor, ut pharetra nulla hendrerit eget. Cras rhoncus neque ut tellus tempor varius id sed nunc. Ut pretium ipsum ac arcu semper, in pellentesque tellus accumsan.</p>
                <p>Vestibulum sapien purus, lacinia a dui vitae, varius lacinia enim. Sed nisi ante, tristique vitae ante scelerisque, luctus placerat metus. Duis vitae leo sollicitudin, tincidunt erat at, tempor magna. Nullam placerat ante in imperdiet consequat. Aliquam ac sagittis tortor. Fusce sed eleifend est, vitae auctor eros. Praesent in felis ante. Duis elementum nibh purus, at malesuada nibh scelerisque quis. Vivamus quis eros elit. Ut hendrerit leo ac gravida rutrum. Nulla facilisi. Vivamus at velit mattis, vehicula eros a, tincidunt ligula. Ut sit amet auctor ante, eget ultrices ante. Maecenas hendrerit ex quis sodales imperdiet. </p>
            </div>
        </div>
        <div class="card mb-3">
            <div class="card-header d-flex">
                <div class="me-auto"><span class="badge bg-secondary">#2</span> | <strong>Felhasználó 4</strong> | 2022. 02. 28. 10:12:23</div>
                <div></div>
            </div>
            <div class="card-body">
                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus tempus tortor orci, ut dignissim urna auctor in. Maecenas molestie fringilla odio, eget euismod magna feugiat a. Duis feugiat purus ultrices orci convallis scelerisque. Aenean ac enim quis mauris ullamcorper tincidunt at a nisl. Suspendisse sollicitudin elit nec nulla pharetra dapibus. Cras finibus lectus vitae pharetra lobortis. Mauris vehicula imperdiet magna a euismod. Nam lobortis a nulla sit amet aliquet. Curabitur nisi neque, interdum vitae dui nec, vulputate pretium nunc. Ut lacinia a arcu vitae imperdiet. Sed eget est ex. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Donec eu neque pulvinar, gravida magna quis, auctor mauris.</p>
                <p>Maecenas elementum quam eu efficitur feugiat. Integer dui augue, convallis sed nisi ac, luctus scelerisque mi. Nullam ut leo eu quam faucibus varius eu at elit. Duis cursus a urna nec fermentum. Fusce vitae dictum orci, lobortis porttitor odio. Nullam tortor risus, rhoncus sed commodo id, egestas a tellus. Pellentesque justo est, posuere vel dictum in, tempor eget nisl. Suspendisse dapibus iaculis justo, mollis hendrerit arcu fermentum vitae. Praesent sem sem, volutpat sit amet egestas a, iaculis ut mauris. Nullam vel eleifend lacus. Praesent quis erat ac mauris suscipit sollicitudin a at nibh. Nulla commodo diam vitae ex sagittis, a congue massa vulputate. Fusce ac accumsan nunc, in aliquam massa. Ut semper risus sit amet tortor ornare, euismod iaculis erat elementum. In congue ut dui eget molestie. Sed sit amet egestas est.</p>
                <p>Praesent egestas, libero eu pulvinar ullamcorper, nulla massa tempor tortor, a laoreet leo ipsum eget dolor. Vivamus gravida enim in eleifend volutpat. Fusce mollis enim dui, at interdum risus sollicitudin et. Nunc dapibus ultricies nibh quis fringilla. Integer luctus ipsum sem, ut hendrerit lacus ultricies tincidunt. Phasellus feugiat congue tempor. Nullam a lacus pellentesque, dictum sapien et, molestie lorem. Aliquam scelerisque ullamcorper lorem, et accumsan sem sodales in. Duis euismod a nibh ut faucibus.</p>
                <p>Nullam iaculis quis est ut sollicitudin. Donec venenatis, nulla nec dapibus faucibus, augue metus consectetur augue, et faucibus quam lectus ut erat. Etiam lacinia tortor vitae lobortis sollicitudin. Nunc mollis felis et tincidunt malesuada. Donec feugiat, orci quis rhoncus viverra, mauris justo malesuada purus, vel eleifend augue leo ac eros. Cras egestas sapien at urna sodales, at rhoncus justo volutpat. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Pellentesque euismod luctus tortor, ut pharetra nulla hendrerit eget. Cras rhoncus neque ut tellus tempor varius id sed nunc. Ut pretium ipsum ac arcu semper, in pellentesque tellus accumsan.</p>
                <p>Vestibulum sapien purus, lacinia a dui vitae, varius lacinia enim. Sed nisi ante, tristique vitae ante scelerisque, luctus placerat metus. Duis vitae leo sollicitudin, tincidunt erat at, tempor magna. Nullam placerat ante in imperdiet consequat. Aliquam ac sagittis tortor. Fusce sed eleifend est, vitae auctor eros. Praesent in felis ante. Duis elementum nibh purus, at malesuada nibh scelerisque quis. Vivamus quis eros elit. Ut hendrerit leo ac gravida rutrum. Nulla facilisi. Vivamus at velit mattis, vehicula eros a, tincidunt ligula. Ut sit amet auctor ante, eget ultrices ante. Maecenas hendrerit ex quis sodales imperdiet. </p>
            </div>
        </div>
        <div class="card mb-3">
            <div class="card-header d-flex">
                <div class="me-auto"><span class="badge bg-secondary">#3</span> | <strong>Felhasználó 4</strong> | 2022. 02. 28. 10:12:23</div>
                <div></div>
            </div>
            <div class="card-body">
                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus tempus tortor orci, ut dignissim urna auctor in. Maecenas molestie fringilla odio, eget euismod magna feugiat a. Duis feugiat purus ultrices orci convallis scelerisque. Aenean ac enim quis mauris ullamcorper tincidunt at a nisl. Suspendisse sollicitudin elit nec nulla pharetra dapibus. Cras finibus lectus vitae pharetra lobortis. Mauris vehicula imperdiet magna a euismod. Nam lobortis a nulla sit amet aliquet. Curabitur nisi neque, interdum vitae dui nec, vulputate pretium nunc. Ut lacinia a arcu vitae imperdiet. Sed eget est ex. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Donec eu neque pulvinar, gravida magna quis, auctor mauris.</p>
                <p>Maecenas elementum quam eu efficitur feugiat. Integer dui augue, convallis sed nisi ac, luctus scelerisque mi. Nullam ut leo eu quam faucibus varius eu at elit. Duis cursus a urna nec fermentum. Fusce vitae dictum orci, lobortis porttitor odio. Nullam tortor risus, rhoncus sed commodo id, egestas a tellus. Pellentesque justo est, posuere vel dictum in, tempor eget nisl. Suspendisse dapibus iaculis justo, mollis hendrerit arcu fermentum vitae. Praesent sem sem, volutpat sit amet egestas a, iaculis ut mauris. Nullam vel eleifend lacus. Praesent quis erat ac mauris suscipit sollicitudin a at nibh. Nulla commodo diam vitae ex sagittis, a congue massa vulputate. Fusce ac accumsan nunc, in aliquam massa. Ut semper risus sit amet tortor ornare, euismod iaculis erat elementum. In congue ut dui eget molestie. Sed sit amet egestas est.</p>
                <p>Praesent egestas, libero eu pulvinar ullamcorper, nulla massa tempor tortor, a laoreet leo ipsum eget dolor. Vivamus gravida enim in eleifend volutpat. Fusce mollis enim dui, at interdum risus sollicitudin et. Nunc dapibus ultricies nibh quis fringilla. Integer luctus ipsum sem, ut hendrerit lacus ultricies tincidunt. Phasellus feugiat congue tempor. Nullam a lacus pellentesque, dictum sapien et, molestie lorem. Aliquam scelerisque ullamcorper lorem, et accumsan sem sodales in. Duis euismod a nibh ut faucibus.</p>
                <p>Nullam iaculis quis est ut sollicitudin. Donec venenatis, nulla nec dapibus faucibus, augue metus consectetur augue, et faucibus quam lectus ut erat. Etiam lacinia tortor vitae lobortis sollicitudin. Nunc mollis felis et tincidunt malesuada. Donec feugiat, orci quis rhoncus viverra, mauris justo malesuada purus, vel eleifend augue leo ac eros. Cras egestas sapien at urna sodales, at rhoncus justo volutpat. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Pellentesque euismod luctus tortor, ut pharetra nulla hendrerit eget. Cras rhoncus neque ut tellus tempor varius id sed nunc. Ut pretium ipsum ac arcu semper, in pellentesque tellus accumsan.</p>
                <p>Vestibulum sapien purus, lacinia a dui vitae, varius lacinia enim. Sed nisi ante, tristique vitae ante scelerisque, luctus placerat metus. Duis vitae leo sollicitudin, tincidunt erat at, tempor magna. Nullam placerat ante in imperdiet consequat. Aliquam ac sagittis tortor. Fusce sed eleifend est, vitae auctor eros. Praesent in felis ante. Duis elementum nibh purus, at malesuada nibh scelerisque quis. Vivamus quis eros elit. Ut hendrerit leo ac gravida rutrum. Nulla facilisi. Vivamus at velit mattis, vehicula eros a, tincidunt ligula. Ut sit amet auctor ante, eget ultrices ante. Maecenas hendrerit ex quis sodales imperdiet. </p>
            </div>
        </div>
        <div class="card mb-3">
            <div class="card-header d-flex">
                <div class="me-auto"><span class="badge bg-secondary">#4</span> | <strong>Felhasználó 2</strong> | 2022. 02. 28. 10:12:23</div>
                <div><a href="#"><i class="fa-solid fa-download"></i></a></div>
            </div>
            <div class="card-body">
                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus tempus tortor orci, ut dignissim urna auctor in. Maecenas molestie fringilla odio, eget euismod magna feugiat a. Duis feugiat purus ultrices orci convallis scelerisque. Aenean ac enim quis mauris ullamcorper tincidunt at a nisl. Suspendisse sollicitudin elit nec nulla pharetra dapibus. Cras finibus lectus vitae pharetra lobortis. Mauris vehicula imperdiet magna a euismod. Nam lobortis a nulla sit amet aliquet. Curabitur nisi neque, interdum vitae dui nec, vulputate pretium nunc. Ut lacinia a arcu vitae imperdiet. Sed eget est ex. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Donec eu neque pulvinar, gravida magna quis, auctor mauris.</p>
                <p>Maecenas elementum quam eu efficitur feugiat. Integer dui augue, convallis sed nisi ac, luctus scelerisque mi. Nullam ut leo eu quam faucibus varius eu at elit. Duis cursus a urna nec fermentum. Fusce vitae dictum orci, lobortis porttitor odio. Nullam tortor risus, rhoncus sed commodo id, egestas a tellus. Pellentesque justo est, posuere vel dictum in, tempor eget nisl. Suspendisse dapibus iaculis justo, mollis hendrerit arcu fermentum vitae. Praesent sem sem, volutpat sit amet egestas a, iaculis ut mauris. Nullam vel eleifend lacus. Praesent quis erat ac mauris suscipit sollicitudin a at nibh. Nulla commodo diam vitae ex sagittis, a congue massa vulputate. Fusce ac accumsan nunc, in aliquam massa. Ut semper risus sit amet tortor ornare, euismod iaculis erat elementum. In congue ut dui eget molestie. Sed sit amet egestas est.</p>
                <p>Praesent egestas, libero eu pulvinar ullamcorper, nulla massa tempor tortor, a laoreet leo ipsum eget dolor. Vivamus gravida enim in eleifend volutpat. Fusce mollis enim dui, at interdum risus sollicitudin et. Nunc dapibus ultricies nibh quis fringilla. Integer luctus ipsum sem, ut hendrerit lacus ultricies tincidunt. Phasellus feugiat congue tempor. Nullam a lacus pellentesque, dictum sapien et, molestie lorem. Aliquam scelerisque ullamcorper lorem, et accumsan sem sodales in. Duis euismod a nibh ut faucibus.</p>
                <p>Nullam iaculis quis est ut sollicitudin. Donec venenatis, nulla nec dapibus faucibus, augue metus consectetur augue, et faucibus quam lectus ut erat. Etiam lacinia tortor vitae lobortis sollicitudin. Nunc mollis felis et tincidunt malesuada. Donec feugiat, orci quis rhoncus viverra, mauris justo malesuada purus, vel eleifend augue leo ac eros. Cras egestas sapien at urna sodales, at rhoncus justo volutpat. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Pellentesque euismod luctus tortor, ut pharetra nulla hendrerit eget. Cras rhoncus neque ut tellus tempor varius id sed nunc. Ut pretium ipsum ac arcu semper, in pellentesque tellus accumsan.</p>
                <p>Vestibulum sapien purus, lacinia a dui vitae, varius lacinia enim. Sed nisi ante, tristique vitae ante scelerisque, luctus placerat metus. Duis vitae leo sollicitudin, tincidunt erat at, tempor magna. Nullam placerat ante in imperdiet consequat. Aliquam ac sagittis tortor. Fusce sed eleifend est, vitae auctor eros. Praesent in felis ante. Duis elementum nibh purus, at malesuada nibh scelerisque quis. Vivamus quis eros elit. Ut hendrerit leo ac gravida rutrum. Nulla facilisi. Vivamus at velit mattis, vehicula eros a, tincidunt ligula. Ut sit amet auctor ante, eget ultrices ante. Maecenas hendrerit ex quis sodales imperdiet. </p>
            </div>
        </div>
        <div class="card mb-3">
            <div class="card-header d-flex">
                <div class="me-auto"><span class="badge bg-secondary">#5</span> | <strong>Felhasználó 1</strong> | 2022. 02. 28. 10:12:23</div>
                <div></div>
            </div>
            <div class="card-body">
                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus tempus tortor orci, ut dignissim urna auctor in. Maecenas molestie fringilla odio, eget euismod magna feugiat a. Duis feugiat purus ultrices orci convallis scelerisque. Aenean ac enim quis mauris ullamcorper tincidunt at a nisl. Suspendisse sollicitudin elit nec nulla pharetra dapibus. Cras finibus lectus vitae pharetra lobortis. Mauris vehicula imperdiet magna a euismod. Nam lobortis a nulla sit amet aliquet. Curabitur nisi neque, interdum vitae dui nec, vulputate pretium nunc. Ut lacinia a arcu vitae imperdiet. Sed eget est ex. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Donec eu neque pulvinar, gravida magna quis, auctor mauris.</p>
                <p>Maecenas elementum quam eu efficitur feugiat. Integer dui augue, convallis sed nisi ac, luctus scelerisque mi. Nullam ut leo eu quam faucibus varius eu at elit. Duis cursus a urna nec fermentum. Fusce vitae dictum orci, lobortis porttitor odio. Nullam tortor risus, rhoncus sed commodo id, egestas a tellus. Pellentesque justo est, posuere vel dictum in, tempor eget nisl. Suspendisse dapibus iaculis justo, mollis hendrerit arcu fermentum vitae. Praesent sem sem, volutpat sit amet egestas a, iaculis ut mauris. Nullam vel eleifend lacus. Praesent quis erat ac mauris suscipit sollicitudin a at nibh. Nulla commodo diam vitae ex sagittis, a congue massa vulputate. Fusce ac accumsan nunc, in aliquam massa. Ut semper risus sit amet tortor ornare, euismod iaculis erat elementum. In congue ut dui eget molestie. Sed sit amet egestas est.</p>
                <p>Praesent egestas, libero eu pulvinar ullamcorper, nulla massa tempor tortor, a laoreet leo ipsum eget dolor. Vivamus gravida enim in eleifend volutpat. Fusce mollis enim dui, at interdum risus sollicitudin et. Nunc dapibus ultricies nibh quis fringilla. Integer luctus ipsum sem, ut hendrerit lacus ultricies tincidunt. Phasellus feugiat congue tempor. Nullam a lacus pellentesque, dictum sapien et, molestie lorem. Aliquam scelerisque ullamcorper lorem, et accumsan sem sodales in. Duis euismod a nibh ut faucibus.</p>
                <p>Nullam iaculis quis est ut sollicitudin. Donec venenatis, nulla nec dapibus faucibus, augue metus consectetur augue, et faucibus quam lectus ut erat. Etiam lacinia tortor vitae lobortis sollicitudin. Nunc mollis felis et tincidunt malesuada. Donec feugiat, orci quis rhoncus viverra, mauris justo malesuada purus, vel eleifend augue leo ac eros. Cras egestas sapien at urna sodales, at rhoncus justo volutpat. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Pellentesque euismod luctus tortor, ut pharetra nulla hendrerit eget. Cras rhoncus neque ut tellus tempor varius id sed nunc. Ut pretium ipsum ac arcu semper, in pellentesque tellus accumsan.</p>
                <p>Vestibulum sapien purus, lacinia a dui vitae, varius lacinia enim. Sed nisi ante, tristique vitae ante scelerisque, luctus placerat metus. Duis vitae leo sollicitudin, tincidunt erat at, tempor magna. Nullam placerat ante in imperdiet consequat. Aliquam ac sagittis tortor. Fusce sed eleifend est, vitae auctor eros. Praesent in felis ante. Duis elementum nibh purus, at malesuada nibh scelerisque quis. Vivamus quis eros elit. Ut hendrerit leo ac gravida rutrum. Nulla facilisi. Vivamus at velit mattis, vehicula eros a, tincidunt ligula. Ut sit amet auctor ante, eget ultrices ante. Maecenas hendrerit ex quis sodales imperdiet. </p>
            </div>
        </div>
        <div class="card mb-3">
            <div class="card-header d-flex">
                <div class="me-auto"><span class="badge bg-secondary">#6</span> | <strong>Felhasználó 3</strong> | 2022. 02. 28. 10:12:23</div>
                <div><a href="#"><i class="fa-solid fa-download"></i></a></div>
            </div>
            <div class="card-body">
                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus tempus tortor orci, ut dignissim urna auctor in. Maecenas molestie fringilla odio, eget euismod magna feugiat a. Duis feugiat purus ultrices orci convallis scelerisque. Aenean ac enim quis mauris ullamcorper tincidunt at a nisl. Suspendisse sollicitudin elit nec nulla pharetra dapibus. Cras finibus lectus vitae pharetra lobortis. Mauris vehicula imperdiet magna a euismod. Nam lobortis a nulla sit amet aliquet. Curabitur nisi neque, interdum vitae dui nec, vulputate pretium nunc. Ut lacinia a arcu vitae imperdiet. Sed eget est ex. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Donec eu neque pulvinar, gravida magna quis, auctor mauris.</p>
                <p>Maecenas elementum quam eu efficitur feugiat. Integer dui augue, convallis sed nisi ac, luctus scelerisque mi. Nullam ut leo eu quam faucibus varius eu at elit. Duis cursus a urna nec fermentum. Fusce vitae dictum orci, lobortis porttitor odio. Nullam tortor risus, rhoncus sed commodo id, egestas a tellus. Pellentesque justo est, posuere vel dictum in, tempor eget nisl. Suspendisse dapibus iaculis justo, mollis hendrerit arcu fermentum vitae. Praesent sem sem, volutpat sit amet egestas a, iaculis ut mauris. Nullam vel eleifend lacus. Praesent quis erat ac mauris suscipit sollicitudin a at nibh. Nulla commodo diam vitae ex sagittis, a congue massa vulputate. Fusce ac accumsan nunc, in aliquam massa. Ut semper risus sit amet tortor ornare, euismod iaculis erat elementum. In congue ut dui eget molestie. Sed sit amet egestas est.</p>
                <p>Praesent egestas, libero eu pulvinar ullamcorper, nulla massa tempor tortor, a laoreet leo ipsum eget dolor. Vivamus gravida enim in eleifend volutpat. Fusce mollis enim dui, at interdum risus sollicitudin et. Nunc dapibus ultricies nibh quis fringilla. Integer luctus ipsum sem, ut hendrerit lacus ultricies tincidunt. Phasellus feugiat congue tempor. Nullam a lacus pellentesque, dictum sapien et, molestie lorem. Aliquam scelerisque ullamcorper lorem, et accumsan sem sodales in. Duis euismod a nibh ut faucibus.</p>
                <p>Nullam iaculis quis est ut sollicitudin. Donec venenatis, nulla nec dapibus faucibus, augue metus consectetur augue, et faucibus quam lectus ut erat. Etiam lacinia tortor vitae lobortis sollicitudin. Nunc mollis felis et tincidunt malesuada. Donec feugiat, orci quis rhoncus viverra, mauris justo malesuada purus, vel eleifend augue leo ac eros. Cras egestas sapien at urna sodales, at rhoncus justo volutpat. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Pellentesque euismod luctus tortor, ut pharetra nulla hendrerit eget. Cras rhoncus neque ut tellus tempor varius id sed nunc. Ut pretium ipsum ac arcu semper, in pellentesque tellus accumsan.</p>
                <p>Vestibulum sapien purus, lacinia a dui vitae, varius lacinia enim. Sed nisi ante, tristique vitae ante scelerisque, luctus placerat metus. Duis vitae leo sollicitudin, tincidunt erat at, tempor magna. Nullam placerat ante in imperdiet consequat. Aliquam ac sagittis tortor. Fusce sed eleifend est, vitae auctor eros. Praesent in felis ante. Duis elementum nibh purus, at malesuada nibh scelerisque quis. Vivamus quis eros elit. Ut hendrerit leo ac gravida rutrum. Nulla facilisi. Vivamus at velit mattis, vehicula eros a, tincidunt ligula. Ut sit amet auctor ante, eget ultrices ante. Maecenas hendrerit ex quis sodales imperdiet. </p>
            </div>
        </div>
        <hr>
        <h2>Új hozzászólás írása</h2>
        <form>
            <div class="mb-3">
                <textarea class="form-control" name="text" id="text" cols="30" rows="10" placeholder="Hozzászólás..."></textarea>
            </div>
            <div class="mb-3">
                <input type="file" class="form-control" id="file">
            </div>
            <div class="row">
                <button type="submit" class="btn btn-primary">Küldés</button>
            </div>
        </form>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
    <script>
        var tooltipTriggerList = [].slice.call(
            document.querySelectorAll('[data-bs-toggle="tooltip"]')
        );
        var tooltipList = tooltipTriggerList.map(function(tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
    </script>
</body>

</html>
