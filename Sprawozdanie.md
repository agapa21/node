# Sprawozdanie 5
---
# Instalacja klastra Kubernetes
Należało zaopatrzeć się w minikube na swojej maszynie, więc po pobraniu odpowiedniego pliku należało uruchomić minikube poleceniem `minikube start`.

![image](pngs/1..PNG)

Jak widać start nie zadziałał. Po wykonaniu zasugerowanej komendy, minikube wkońcu został uruchomiony.

![image](pngs/2.PNG)

Jego działanie można potwierdzić wykonując polecenie `docker ps`.

![image](pngs/3.PNG)

Aby zapewnić bezpieczeństwo podczas instalacji należało upewnić się czy:
- nasza maszyna spełnia odpowiednie wymagania systemowe tj. posiadanie wirtualizacji lub odpowiedniej wersji systemu operacyjnego,
  -  ważne jest aby system operacyjny, sterowniki wirtualizacji (np. Docker), a także Minikube są zaktualizowane do najnowszych wersji,
- postępujemy zgodnie z instrukcjami dostępnymi na oficjalnej stronie Minikube,
- pobierane pliki są z zaufanego źródła,

Należało również zaopatrzeć się w polecenie `kubectl`.

![image](pngs/4.PNG)

Następnie przeszłam do uruchomienia Kubernetesa:
- poleceniem `kubectl get po -A` wyświetlam listy wszystkich działających podów

![image](pngs/5.PNG)

- poleceniem `minikube dashboard` uruchamiam interaktywny pulpit nawigacyjny dla klastra Kubernetes działającego lokalnie za pomocą narzędzia Minikube.

![image](pngs/6.PNG)

- automatycznie otwiera się okno przeglądarki z Kubernetesem:

![image](pngs/7.PNG)

Wymagania sprzętowe, które należało zapewnić do poprawnego zainstalowania/uruchomienia Kubernetesa za pomocą Minikube:
1. Posiadanie wirtualizacji - u mnie o dziwo poprzednich prac z Dockerem pojawił się ten problem. Ze względu na małe problemy z poprzednią maszyną wirtualną, zdecydowałam się stworzyć nową. Tak więc, przy uruchamianiu minikube po raz pierwszy, skorzystał on ze sterownika VirtualBox. Dopiero po pobraniu Dockera i ustawieniu go jako "driver", wszystko zadziałało tak jak należy.
2. Wystarczająca ilość pamięci RAM (20 GB).
3. Minimum 2 CPU.
4. Połączenie z siecią.
5. Odpowiednia ilość pamięci operacyjnej (2GB).
Dzięki nowo postawionej maszynie udało się ominąć potencjalne problemy wynikające z niespełnienia wymagań sprzętowych.

# Uruchamianie oprogramowania

Zabawę z Kubernetesem rozpoczynam od przykładu wziętego z oficjalnej strony:
- tworzę "deployment" o nazwie "hello-minikube", używając obrazu "kicbase/echo-server" w wersji 1.0:
- tworzę service, który eksponuje deployment o nazwie "hello-minikube1" na porcie 8080 i typie LoadBalancer.

![image](pngs/9.PNG)

- w celu umożliwienia bezpośredniego dostępu z lokalnego komputera do usługi działającej w klastrze, wykonuję przekierownie portów:

![image](pngs/10.PNG)

Efekt:
- odpytywany adres localhost:7080:

![image](pngs/11.PNG)

- kubernetes dashboard:

![image](pngs/12.PNG)

- stan podów w klastrze:

![image](pngs/13.PNG)

# Wdrażanie na zarządzalne kontenery: Kubernetes (2)

Zdecydowałam się na skorzystanie z zaproponowanego w instrukcji "gotowca" httpd.

Rozpoczełam pracę od uruchomienia obrazu httpd:latest.

![image](pngs/14.PNG)

Przekierowuje na odpowiedni port:

![image](pngs/15.PNG)

![image](pngs/16.PNG)
















