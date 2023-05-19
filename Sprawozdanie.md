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

Tworzę plik konfiguracyjny dla wdrożenia Kubernetes:
- służy do zdefiniowania i opisania sposobu uruchomienia usługi w klastrze. W pliku określa się parametry takie jak liczba replik, obraz kontenera, porty do nasłuchiwania i inne właściwości potrzebne do poprawnego wdrożenia aplikacji.

```bash
apiVersion: apps/v1

kind: Deployment
metadata:
  annotations:
    kompose.cmd: kompose convert -f httpdbs.yml
    kompose.version: 1.22.0 (955b78124)
  creationTimestamp: null
  labels:
    io.kompose.service: httpd
  name: httpd
spec:
  replicas: 0
  selector:
    matchLabels:
      io.kompose.service: httpd
  strategy: 
    type: Recreate     
  template:
    metadata:
      annotations:
        kompose.cmd: kompose convert -f httpdbs.yml
        kompose.version: 1.22.0 (955b78124)
      creationTimestamp: null
      labels:
        io.kompose.service: httpd
    spec:
      containers:
        - image: httpd:bullseye
          name: httpd
          ports:
            - containerPort: 80
          resources: {}
      restartPolicy: Always
status: {}
```

Wdrażam definicję zasobu zawarte w pliku poleceniem `kubectl apply`:

![image](pngs/18.PNG)

Po wykonaniu wdrożenia aplikacji lub aktualizacji jej konfiguracji, komenda "kubectl rollout status" umożliwia sprawdzenie postępu procesu wdrożenia.

![image](pngs/19.PNG)

# Zmiany w deploymencie

- obraz wzbogacony o 4 repliki:

![image](pngs/20.PNG)

![image](pngs/25.PNG)

- zmniejszenie liczby replik do 1:

![image](pngs/26.PNG)

- zmniejszenie liczby replik do 0:

![image](pngs/27.PNG)

- zastosowanie starszej wersji obrazu:

![image](pngs/23.PNG)

![image](pngs/22.PNG)

- zastosowanie nowszej wersji obrazu:

![image](pngs/21.PNG)

- zastosowanie polecenia `kubectl rollout history`:
  - służy ona do wyświetlania historii wersji wdrożeń

![image](pngs/28.PNG)

- zastosowanie polecenia `kubectl rollout undo`:
  - służy do cofania ostatniej aktualizacji wdrożenia
  
 ![image](pngs/29.PNG) 
  
# Kontrola wdrożenia
Skrypt weryfikujący, czy wdrożenie "zdążyło" się wdrożyć w 60 sekund:

```bash
#!/bin/bash

kubectl apply -f httpd-deployment.yaml
sleep 60
check=$(kubectl rollout status deployment/httpd)

if [[ "$check" = *"successfully"* ]];
then
        echo "good news :)"
        kubectl rollout status deployment httpd
else
        echo "bad news :("
        kubectl rollout status deployment httpd
        kubectl rollout undo deployment httpd
fi
```

![image](pngs/30.PNG)

# Strategie wdrożenia
Kubernetes oferuje różne strategie wdrożeń, które pozwalają kontrolować sposób, w jaki wdrożenia są aktualizowane i zarządzane.

Stworzenie wersji wdrożeń stosujące następujące strategie:

![image](pngs/34.PNG)

- Recreate:
  - W strategii "Recreate", całe istniejące wdrożenie jest zatrzymywane i usuwane, a następnie tworzone jest nowe wdrożenie z zaktualizowaną wersją aplikacji. Ta strategia powoduje okresową niedostępność aplikacji podczas procesu aktualizacji.
  
![image](pngs/31.PNG)
  
- Rolling Update:
  - Jest to domyślna strategia wdrożenia w Kubernetes. Polega na stopniowym aktualizowaniu replik wdrożenia, jednocześnie zatrzymując i uruchamiając nowe repliki z nową wersją aplikacji. To pozwala na płynne przejście do nowej wersji, minimalizując czas niedostępności aplikacji.
  
![image](pngs/32.PNG)

- Canary Deployment:
  - Ta strategia polega na wprowadzeniu nowej wersji aplikacji tylko dla małej grupy użytkowników. Pozwala na testowanie nowej wersji w rzeczywistych warunkach przed pełnym wdrożeniem. Jeśli nowa wersja jest stabilna i nie powoduje problemów, może być stopniowo wdrażana dla większej liczby użytkowników.

Tak więc w tym przypadku, wdrożone są dwa deploymenty na raz. Jeden z najnowszą wersją usługi, drugi zaś ze starą wersją.

![image](pngs/33.PNG)
