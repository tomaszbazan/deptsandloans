Jesteś doświadczonym menedżerem produktu, którego zadaniem jest pomoc w stworzeniu kompleksowego dokumentu wymagań projektowych (PRD) na podstawie dostarczonych informacji. Twoim celem jest wygenerowanie listy pytań i zaleceń, które zostaną wykorzystane w kolejnym promptowaniu do utworzenia pełnego PRD.

Prosimy o uważne zapoznanie się z poniższymi informacjami:

<project_description>
# Aplikacja - Depts and loans (MVP)

## Główny problem
Ludzie którzy udzielają pożyczek nie dostają zwrotu na czas i potrzebują przypomnienia, że powinni upomnieć się o zwrot i odzyskać środki.
Ludzie którzy pożyczają pieniądze zapominają oddać i potrzebują przypomnienia, aby oddać pieniądze na czas.

## Najmniejszy zestaw funkcjonalności
- Wyświetlenie listy pożyczek i długów
- Dodanie długu zawierającego nazwę, kwotę (z walutą), opcjonalnie opis, datę pożyczki, datę zwrotu oraz propozycję przypomnienia o zwrocie
- Dodanie pożyczki zawierającego nazwę, kwotę (z walutą), opcjonalnie opis, datę pożyczki, datę zwrotu oraz propozycję przypomnienia o zwrocie
- Ustawienie przypomnienia jednorazowego lub cykliczenego
- Ustawienie długi lub pożyczki jako zakończonego
  </project_description>

Przeanalizuj dostarczone informacje, koncentrując się na aspektach istotnych dla tworzenia PRD. Rozważ następujące kwestie:
<prd_analysis>
1. Zidentyfikuj główny problem, który produkt ma rozwiązać.
2. Określ kluczowe funkcjonalności MVP.
3. Rozważ potencjalne historie użytkownika i ścieżki korzystania z produktu.
4. Pomyśl o kryteriach sukcesu i sposobach ich mierzenia.
5. Oceń ograniczenia projektowe i ich wpływ na rozwój produktu.
   </prd_analysis>

Na podstawie analizy wygeneruj listę 10 pytań i zaleceń w formie łączonej (pytanie + zalecenie). Powinny one dotyczyć wszelkich niejasności, potencjalnych problemów lub obszarów, w których potrzeba więcej informacji, aby stworzyć skuteczny PRD. Rozważ pytania dotyczące:

1. Szczegółów problemu użytkownika
2. Priorytetyzacji funkcjonalności
3. Oczekiwanego doświadczenia użytkownika
4. Mierzalnych wskaźników sukcesu
5. Potencjalnych ryzyk i wyzwań
6. Harmonogramu i zasobów

<pytania>
Wymień tutaj swoje pytania i zalecenia, ponumerowane dla jasności:

Przykładowo:
1. Czy już od startu projektu planujesz wprowadzenie płatnych subskrypcji?

Rekomendacja: Pierwszy etap projektu może skupić się na funkcjonalnościach darmowych, aby przyciągnąć użytkowników, a płatne funkcje można wprowadzić w późniejszym etapie.
</pytania>

Kontynuuj ten proces, generując nowe pytania i rekomendacje w oparciu o odpowiedzi użytkownika, dopóki użytkownik wyraźnie nie poprosi o podsumowanie.

Pamiętaj, aby skupić się na jasności, trafności i dokładności wyników. Nie dołączaj żadnych dodatkowych komentarzy ani wyjaśnień poza określonym formatem wyjściowym.

Pracę analityczną należy przeprowadzić w bloku myślenia. Końcowe dane wyjściowe powinny składać się wyłącznie z pytań i zaleceń i nie powinny powielać ani powtarzać żadnej pracy wykonanej w sekcji prd_analysis.

---------

Oto lista 10 pytań i zaleceń, które pomogą w doprecyzowaniu wymagań dla aplikacji "Debts and loans" (MVP) i stworzeniu kompletnego PRD:

1. **Model interakcji użytkowników**
   **Pytanie:** Czy aplikacja ma działać jako jednostronny „notatnik” (użytkownik sam zapisuje kto mu jest winien pieniądze), czy wymaga, aby obie strony (pożyczkodawca i pożyczkobiorca) miały zainstalowaną aplikację i potwierdzały transakcje?
   **Rekomendacja:** Dla MVP zalecam model „jednostronny” (osobisty rejestr). Eliminuje to barierę wejścia (nie muszę namawiać dłużnika do instalacji aplikacji) i znacznie upraszcza logikę backendową.

2. **Sposób realizacji przypomnień**
   **Pytanie:** W jaki sposób mają być realizowane „propozycje przypomnienia o zwrocie”? Czy aplikacja ma wysyłać powiadomienie Push tylko do użytkownika, czy może automatycznie wysyłać SMS/e-mail do dłużnika?
   **Rekomendacja:** Sugeruję powiadomienia Push do użytkownika aplikacji („Przypomnij Markowi o długu”). Po kliknięciu w powiadomienie, użytkownik mógłby zostać przeniesiony do wygenerowanej wiadomości (SMS/WhatsApp/Messenger) z gotową treścią do wysłania, co daje kontrolę nad komunikacją.

3. **Obsługa walut**
   **Pytanie:** Jak zaawansowana ma być obsługa walut? Czy aplikacja ma pobierać kursy walut i sumować długi w jednej walucie bazowej, czy tylko wyświetlać symbol waluty przy konkretnym długu?
   **Rekomendacja:** W MVP warto ograniczyć się do przypisania waluty do konkretnej transakcji (np. wybór z listy PLN, EUR, USD) bez przeliczania kursów i sumowania całości majątku. To skomplikowałoby MVP nieproporcjonalnie do wartości.

4. **Integracja z listą kontaktów**
   **Pytanie:** Czy pole „Nazwa” przy dodawaniu długu/pożyczki ma być wpisywane ręcznie, czy planujemy integrację z książką adresową telefonu?
   **Rekomendacja:** Zalecam integrację z kontaktami. Ułatwi to wprowadzanie danych (wybór osoby z listy) i umożliwi późniejsze łatwe wysyłanie przypomnień (mamy numer telefonu/email).

5. **Częściowe spłaty**
   **Pytanie:** Czy funkcja „zakończenia” długu/pożyczki jest binarna (spłacone/niespłacone), czy dopuszczamy możliwość spłacania ratami (np. pożyczono 1000 zł, oddano 200 zł, pozostało 800 zł)?
   **Rekomendacja:** Warto uwzględnić częściowe spłaty już w MVP. Jest to bardzo częsty scenariusz życiowy, a brak tej funkcji może zniechęcić użytkowników do korzystania z aplikacji przy większych kwotach.

6. **Logika przypomnień cyklicznych**
   **Pytanie:** Jak definiujemy „przypomnienie cykliczne”? Czy chodzi o spłatę w ratach (harmonogram), czy o powtarzające się „nękanie” o tę samą kwotę (np. przypominaj co tydzień, aż oznaczę jako spłacone)?
   **Rekomendacja:** Dla MVP prostsze i bardziej użyteczne będzie „cykliczne przypominanie o całości/zaległości” (np. „Przypominaj mi w każdy piątek, żebym upomniał się o zwrot”), zamiast budowania skomplikowanego harmonogramu rat.

7. **Rejestracja i przechowywanie danych**
   **Pytanie:** Czy aplikacja ma działać offline z danymi zapisanymi lokalnie na urządzeniu, czy wymagane jest założenie konta i synchronizacja w chmurze?
   **Rekomendacja:** Zalecam podejście „Local First”. Użytkownik może korzystać z aplikacji natychmiast po instalacji bez rejestracji (dane na telefonie). Opcjonalna rejestracja (backup danych) może być dodana w wersji 1.1 lub jako funkcja Premium.

8. **Bezpieczeństwo dostępu**
   **Pytanie:** Biorąc pod uwagę, że aplikacja dotyczy finansów, czy wymagane jest dodatkowe zabezpieczenie dostępu do aplikacji (PIN, biometria)?
   **Rekomendacja:** Tak, nawet w MVP warto dodać opcjonalną blokadę biometryczną (FaceID/TouchID) lub prosty PIN przy uruchamianiu aplikacji. Zwiększa to zaufanie użytkownika do narzędzia.

9. **Historia transakcji**
   **Pytanie:** Co dzieje się z długiem po oznaczeniu go jako „zakończony”? Czy znika on z widoku, czy trafia do osobnej zakładki „Archiwum”?
   **Rekomendacja:** Długi powinny trafiać do zakładki „Historia/Archiwum”. Użytkownicy często chcą sprawdzić, czy dana osoba oddała pieniądze w przeszłości, zanim pożyczą jej ponownie.

10. **Platforma docelowa**
    **Pytanie:** Na jakie platformy planujemy wypuścić MVP? Czy jest to natywna aplikacja mobilna (iOS/Android), czy może PWA (strona www)?
    **Rekomendacja:** Ze względu na kluczową rolę powiadomień (push) oraz integracji z kontaktami, rekomenduję stworzenie aplikacji mobilnej (np. w technologii cross-platformowej jak Flutter lub React Native), aby jednym kodem obsłużyć iOS i Androida.

-----

1. Zgadzam się z rekomendacją.
2. Dla MVP wystarczy powiadomienie push.
3. Dla MVP wystarczy predefiniowana lista najpopularniejszych walut.
4. Dla MVP wystarczy zwykły tekst, integrację z kontaktami możemy dodać później.
5. Zgadzam się z rekomendacją. Możemy dodać częściową spłatę.
6. Wystarczy opcja: "przypomnij mi co X dni o abym upomniał się o zwrot".
7. Dla MVP wystarczy lokalne zapisywanie danych.
8. Dla MVP nie ma potrzeby dodawania takiej funkcjonalności.
9. Poniżej listy z długami/pożyczkami powinna się znaleźć lista zawierająca archiwum.
10. Na start aplikacja będzie uruchamiana tylko na Android i napisana w Flutter, aby w kolejnych iteracjach uruchomić ją na iOS.

-----

Dziękuję za konkretne odpowiedzi. Kształt MVP staje się coraz wyraźniejszy. Przejdźmy do drugiej rundy pytań, aby doprecyzować szczegóły interfejsu, logiki biznesowej oraz obsługi błędów, co jest kluczowe dla programistów.

Oto kolejne 10 pytań i rekomendacji:

11. **Organizacja widoku głównego (Dashboard)**
    **Pytanie:** W jaki sposób chcesz rozdzielić "Długi" (ja wiszę komuś) od "Pożyczek" (ktoś wisi mi)? Czy mają to być dwie osobne zakładki (Tabs) na górze/dole ekranu, czy jedna lista z rozróżnieniem kolorystycznym (np. czerwony/zielony)?
    **Rekomendacja:** Sugeruję zastosowanie dwóch zakładek na górze ekranu: "Moje Długi" i "Moje Pożyczki". To najczystsze rozwiązanie, które zapobiega pomyłkom przy szybkim przeglądaniu salda.

12. **Interfejs częściowej spłaty**
    **Pytanie:** Jak użytkownik ma odnotować częściową spłatę? Czy wchodząc w szczegóły długu ma edytować "kwotę całkowitą", czy powinien mieć przycisk "Dodaj spłatę", gdzie wpisuje tylko oddawaną kwotę, a system sam przelicza resztę?
    **Rekomendacja:** Zdecydowanie rekomenduję przycisk "Dodaj spłatę" (lub ikonę "+" przy pasku postępu). Pozwala to zachować historię (np. "20.03 oddano 200 zł") i buduje lepsze poczucie postępu niż zwykła edycja kwoty głównej.

13. **Sortowanie listy**
    **Pytanie:** W jakiej kolejności domyślnie mają wyświetlać się elementy na liście? (np. od najnowszych dodanych, od największej kwoty, czy od najbliższej daty zwrotu)?
    **Rekomendacja:** Najbardziej użyteczne będzie sortowanie po **dacie zwrotu (rosnąco)**. Długi przeterminowane lub z terminem "na dzisiaj" powinny być na samej górze, wyróżnione kolorem, aby realizować główny cel aplikacji: "przypomnienie o zwrocie na czas".

14. **Lista walut w MVP**
    **Pytanie:** Jakie konkretnie waluty powinny znaleźć się na predefiniowanej liście dla wersji MVP?
    **Rekomendacja:** Sugeruję ograniczyć się do **PLN, EUR, USD, GBP**. Są to najpopularniejsze waluty w naszym regionie. Długa lista rzadkich walut tylko utrudni wybór (chyba że dodamy wyszukiwarkę, co zwiększa koszt MVP).

15. **Edycja i usuwanie wpisów**
    **Pytanie:** Jak obsłużymy pomyłki użytkownika? Czy umożliwiamy edycję wszystkich parametrów długu po jego utworzeniu oraz jego całkowite usunięcie?
    **Rekomendacja:** Tak, pełna edycja jest konieczna. Do usuwania proponuję standardowy gest przesunięcia elementu na liście w lewo (swipe-to-delete) z komunikatem potwierdzającym, aby uniknąć przypadkowego usunięcia.

16. **Logika daty zwrotu**
    **Pytanie:** Czy data zwrotu jest polem obowiązkowym przy tworzeniu długu/pożyczki?
    **Rekomendacja:** Zalecam, aby pole to było **opcjonalne**. Często pożyczamy "do pierwszego" lub "jak będziesz miał", bez konkretnej daty w kalendarzu. Jeśli data nie jest podana, pozycję można wyświetlać na końcu listy lub w sekcji "Bez terminu".

17. **Wygląd Archiwum**
    **Pytanie:** Czy sekcja "Archiwum" (zakończone długi), o której wspomniałeś, ma być widoczna cały czas pod listą aktywną, czy może być zwijana (np. nagłówek "Zakończone", który trzeba kliknąć, by rozwinąć listę)?
    **Rekomendacja:** Sugeruję **listę zwijaną (akordeon)** na dole ekranu. Użytkownik rzadko zagląda do archiwum, więc nie powinno ono zajmować cennej przestrzeni ekranowej potrzebnej na aktywne sprawy.

18. **Godzina powiadomień**
    **Pytanie:** Skoro ustalamy przypomnienie "co X dni", to o jakiej godzinie użytkownik ma otrzymywać powiadomienie push?
    **Rekomendacja:** Dla MVP warto ustalić **sztywną godzinę domyślną, np. 9:00 rano lub 19:00 wieczorem**. Dodawanie konfiguracji godziny dla każdego długu osobno skomplikuje formularz dodawania, a w MVP zależy nam na szybkości wprowadzania danych.

19. **Empty State (Pusty stan)**
    **Pytanie:** Co użytkownik powinien zobaczyć po pierwszym uruchomieniu aplikacji, gdy listy są puste?
    **Rekomendacja:** Prosta grafika/ikona oraz duża strzałka lub napis wskazujący na przycisk dodawania ("Floating Action Button"). Tekst zachęty: "Nie masz jeszcze żadnych wpisów. Dodaj pierwszą pożyczkę".

20. **Pola opisu**
    **Pytanie:** Czy pole "Opis" (opcjonalne) ma limit znaków? Czy ma obsługiwać wiele linii tekstu?
    **Rekomendacja:** Ograniczmy to do np. **140-200 znaków** i pozwólmy na wyświetlanie max 2 linii na liście głównej (reszta widoczna po wejściu w szczegóły). Zbyt długie opisy zaburzą czytelność listy.

-----

11. Tak powinny to być 2 osobne zakładki
12. Po naciśnięciu na dług powinno zostać wyświetlone okno i opcją wpisania kwoty, jeżeli kwota jest mniejsza niż długu to powinien się pojawić pasek postępu na liście długów.
13. Lista powinna być posortowana wg daty zwrotu (jeżeli została podana). W przeciwnym razie po dacie dodania.
14. Wystarczy: PLN, EUR, USD, GBP
15. Edycja lub usunięcie jest możliwe.
16. To pole jest opcjonalne.
17. Może być akordeon.
18. Dla MVP będzie ustawiona godzina na sztywno i będzie to 19:00.
19. Zgadzam się z rekomendacją.
20. Zróbmy ograniczenie do 200 znaków. Na liście głównej wyświetlimy tylko 30 pierwszych znaków.

-----

Dziękuję za doprecyzowanie kluczowych kwestii. Mamy już solidny zarys interfejsu (zakładki, akordeon) i logiki biznesowej (częściowe spłaty, sortowanie).

Przechodzę do trzeciej, prawdopodobnie ostatniej rundy pytań przed podsumowaniem. Skupię się teraz na szczegółach UX, walidacji danych i estetyce, aby PRD był kompletny dla zespołu deweloperskiego i designera.

Oto lista kolejnych pytań i rekomendacji:

21. **Walidacja kwoty spłaty (Overpayment)**
    **Pytanie:** Co ma się stać, jeśli użytkownik przy częściowej spłacie wpisze kwotę wyższą niż pozostały dług? (np. długu zostało 50 zł, użytkownik wpisuje 100 zł).
    **Rekomendacja:** Aplikacja powinna zablokować taką akcję i wyświetlić komunikat walidacyjny: „Kwota spłaty nie może przekraczać wartości długu”. Upraszcza to logikę (brak „reszty” czy ujemnych długów).

22. **Wyróżnienie wizualne przeterminowanych płatności**
    **Pytanie:** W jaki sposób chcemy wyróżnić na liście pozycje, których data zwrotu już minęła?
    **Rekomendacja:** Sugeruję zmianę koloru daty lub kwoty na **czerwony** oraz dodanie małej ikony wykrzyknika przy elemencie listy. To standardowy wzorzec UX dla ostrzeżeń.

23. **Sortowanie elementów bez daty zwrotu**
    **Pytanie:** Ustaliliśmy, że sortujemy po dacie zwrotu, a w drugiej kolejności po dacie dodania. Gdzie na liście powinny lądować elementy **bez** zdefiniowanej daty zwrotu? Na samej górze (priorytet) czy na samym dole (mniej pilne)?
    **Rekomendacja:** Elementy bez daty powinny trafiać na **dół listy** (pod tymi z datami). Zakładamy, że jeśli coś ma termin, jest pilniejsze niż coś, co terminu nie ma.

24. **Automatyczne wyłączanie powiadomień**
    **Pytanie:** Co dzieje się z aktywnym, cyklicznym powiadomieniem, gdy użytkownik spłaci 100% długu (oznaczy jako zakończony)?
    **Rekomendacja:** Powiadomienie powinno zostać **automatycznie anulowane/usunięte** w momencie przejścia długu w stan „zakończony”. Użytkownik nie powinien musieć pamiętać o ręcznym wyłączaniu przypomnień dla spłaconych spraw.

25. **Formatowanie liczb i walut**
    **Pytanie:** Czy formatowanie kwot ma zależeć od ustawień telefonu użytkownika (np. kropka vs przecinek), czy narzucamy polski standard (spacja jako separator tysięcy, przecinek dla groszy)?
    **Rekomendacja:** W Flutterze najlepiej użyć systemowego `Locale` użytkownika. Jeśli telefon jest po polsku, wyświetlamy `1 000,00 zł`, jeśli po angielsku `1,000.00 zł`. To najtańsze i najbardziej intuicyjne rozwiązanie.

26. **Historia częściowych spłat**
    **Pytanie:** Czy po wejściu w szczegóły długu użytkownik powinien widzieć listę dokonanych wpłat (historię), np. „20.03: wpłacono 50 zł”, czy wystarczy tylko informacja „Spłacono 50 z 100 zł”?
    **Rekomendacja:** Dla MVP wystarczy **tylko pasek postępu i informacja sumaryczna** („Pozostało 50 zł”). Budowanie pełnej historii transakcji („ledger”) to dodatkowa tabela w bazie danych i dodatkowy widok, co może być zbyt skomplikowane na ten etap.

27. **Tryb Ciemny (Dark Mode)**
    **Pytanie:** Czy aplikacja w wersji MVP musi obsługiwać tryb ciemny (Dark Mode)?
    **Rekomendacja:** Tak, Flutter wspiera to natywnie bardzo łatwo. Zalecam wdrożenie od razu, ponieważ brak trybu ciemnego jest obecnie źle odbierany przez użytkowników, a koszt wdrożenia na starcie jest niski.

28. **Wersje językowe**
    **Pytanie:** Czy aplikacja w MVP będzie dostępna tylko w języku polskim, czy planujemy od razu wersję angielską?
    **Rekomendacja:** Rekomenduję przygotowanie kodu pod internacjonalizację (i18n), ale w MVP udostępnienie **tylko języka polskiego**. Dodanie angielskiego będzie wtedy proste w przyszłości, a teraz nie opóźni premiery koniecznością tłumaczeń.

29. **Przycisk akcji (Floating Action Button - FAB)**
    **Pytanie:** Gdzie umieszczamy przycisk dodawania nowego długu? Czy jest jeden wspólny, który pyta „Dług czy Pożyczka?”, czy osobny dla każdej zakładki?
    **Rekomendacja:** Jeden przycisk FAB w prawym dolnym rogu. Jeśli użytkownik jest na zakładce „Długi”, przycisk domyślnie otwiera formularz „Dodaj dług”. Jeśli na „Pożyczki” – „Dodaj pożyczkę”. To kontekstowe i intuicyjne.

30. **Zasady walidacji nazwy**
    **Pytanie:** Czy pole „Nazwa” (tytuł długu/osoba) może być puste?
    **Rekomendacja:** Pole to musi być **wymagane**. Dług bez nazwy (od kogo/za co) jest bezużyteczny na liście. Minimalna długość to 1 znak.

**Czy to już wszystkie informacje, czy chcesz jeszcze coś dodać przed wygenerowaniem podsumowania (gotowego wsadu do PRD)?**

-----

21. Nie ma możliwości wpisania kwoty większej niż kwota długu.
22. Zgadzam się z rekomendacją.
23. Powinny znaleźć się na dole listy.
24. Powinny zostać automatycznie anulowane.
25. Powinien się dostosować do ustawień telefonu.
26. Dla MVP wystarczy tylko informacja, że zostało spłacone X z Y.
27. Tak powinniśmy dodać od razu Dark Mode.
28. Powinniśmy dodać od razu język polski oraz angielski, które będą ustawiane z ustawień telefonu (domyślny to angielski)
29. Zgadzam się z rekomendacją.
30. Pole nazwa jest wymagane i nie może być puste przy dodawaniu.

---

Jesteś asystentem AI, którego zadaniem jest podsumowanie rozmowy na temat planowania PRD (Product Requirements Document) dla MVP i przygotowanie zwięzłego podsumowania dla następnego etapu rozwoju. W historii konwersacji znajdziesz następujące informacje:
1. Opis projektu
2. Zidentyfikowany problem użytkownika
3. Historia rozmów zawierająca pytania i odpowiedzi
4. Zalecenia dotyczące zawartości PRD

Twoim zadaniem jest:
1. Podsumować historię konwersacji, koncentrując się na wszystkich decyzjach związanych z planowaniem PRD.
2. Dopasowanie zaleceń modelu do odpowiedzi udzielonych w historii konwersacji. Zidentyfikuj, które zalecenia są istotne w oparciu o dyskusję.
3. Przygotuj szczegółowe podsumowanie rozmowy, które obejmuje:
   a. Główne wymagania funkcjonalne produktu
   b. Kluczowe historie użytkownika i ścieżki korzystania
   c. Ważne kryteria sukcesu i sposoby ich mierzenia
   d. Wszelkie nierozwiązane kwestie lub obszary wymagające dalszego wyjaśnienia
4. Sformatuj wyniki w następujący sposób:

<conversation_summary>
<decisions>
[Wymień decyzje podjęte przez użytkownika, ponumerowane].
</decisions>

<matched_recommendations>
[Lista najistotniejszych zaleceń dopasowanych do rozmowy, ponumerowanych]
</matched_recommendations>

<prd_planning_summary>
[Podaj szczegółowe podsumowanie rozmowy, w tym elementy wymienione w kroku 3].
</prd_planning_summary>

<unresolved_issues>
[Wymień wszelkie nierozwiązane kwestie lub obszary wymagające dalszych wyjaśnień, jeśli takie istnieją]
</unresolved_issues>
</conversation_summary>

Końcowy wynik powinien zawierać tylko treść w formacie markdown. Upewnij się, że Twoje podsumowanie jest jasne, zwięzłe i zapewnia cenne informacje dla następnego etapu tworzenia PRD.

-----

\<conversation_summary>
\<decisions>

1.  **Model interakcji:** Aplikacja działa jako jednostronny, osobisty rejestr długów i pożyczek.
2.  **Platforma/Technologia:** MVP będzie natywną aplikacją mobilną na Androida (Flutter), z planami na iOS w kolejnych iteracjach.
3.  **Funkcjonalność spłat:** Wprowadzono funkcję **częściowej spłaty** z automatycznym przeliczaniem salda i paskiem postępu. Blokowanie wprowadzania kwoty wyższej niż pozostały dług.
4.  **Przechowywanie danych:** Wyłącznie **lokalne** zapisywanie danych na urządzeniu (brak wymaganej rejestracji).
5.  **Przypomnienia:** Powiadomienia **Push** do użytkownika (nie do dłużnika), ustawione na sztywną godzinę **19:00**. Logika cykliczna: „przypomnij co X dni”.
6.  **Anulowanie powiadomień:** Automatyczne anulowanie powiadomień po spłacie 100% długu.
7.  **Struktura UI:** Dwie osobne zakładki: **„Moje Długi”** i **„Moje Pożyczki”**.
8.  **Sortowanie:** Lista aktywnych długów sortowana według **daty zwrotu (jeśli podana)**, a następnie według daty dodania. Elementy bez daty zwrotu umieszczone na dole listy.
9.  **Archiwum:** Lista zakończonych transakcji w formie **zwijanego akordeonu** (Historia) pod listą aktywną.
10. **Waluty:** Ograniczona lista predefiniowanych walut (**PLN, EUR, USD, GBP**). Formatowanie liczb dostosowane do ustawień regionalnych (Locale) telefonu.
11. **Wymagania pól:** **Pole „Nazwa” jest wymagane**. Pole „Data zwrotu” jest opcjonalne. Pole „Opis” jest opcjonalne, ograniczone do 200 znaków (na liście wyświetlane 30 znaków).
12. **UX/Wizualne:** Wdrożenie **Dark Mode** (trybu ciemnego) od MVP. Wizualne wyróżnianie zaległych płatności (np. czerwony kolor).
13. **Języki:** Wsparcie dla języka **polskiego i angielskiego** od startu, ustawiane na podstawie ustawień systemowych (domyślny to angielski).

\</decisions>

-----

\<matched_recommendations>

1.  **Model interakcji:** Aplikacja jako **jednostronny** osobisty rejestr w celu redukcji bariery wejścia.
2.  **Sposób realizacji przypomnień:** Powiadomienia Push do użytkownika z opcją generowania wiadomości do dłużnika (realizowane przez powiadomienia Push do użytkownika).
3.  **Częściowe spłaty:** Wprowadzenie obsługi **częściowych spłat** do MVP, w celu odzwierciedlenia rzeczywistych scenariuszy.
4.  **Organizacja widoku głównego:** Zastosowanie **dwóch zakładek** („Moje Długi” i „Moje Pożyczki”) dla zapewnienia czytelności.
5.  **Sortowanie listy:** Sortowanie po **dacie zwrotu (rosnąco)**, aby priorytetyzować pilne sprawy.
6.  **Logika przypomnień cyklicznych:** Uproszczona logika: „przypomnij mi co X dni” o zaległości.
7.  **Rejestracja i przechowywanie danych:** Model **"Local First"** (lokalne zapisywanie danych) w celu obniżenia bariery wejścia.
8.  **Automatyczne wyłączanie powiadomień:** Powiadomienia powinny zostać **automatycznie anulowane** po spłacie długu.
9.  **Tryb Ciemny:** Wdrożenie obsługi **Dark Mode** ze względu na niski koszt wdrożenia we Flutterze i oczekiwania użytkowników.
10. **Wymagane pola:** Pole „Nazwa” musi być **wymagane** (zgodnie z decyzją), aby utrzymać sens wpisów.
    \</matched_recommendations>

-----

\<prd_planning_summary>

### 🚀 Główne Wymagania Funkcjonalne (MVP)

* **Prowadzenie Rejestru:** Użytkownik może dodawać, edytować i usuwać pożyczki i długi, definiując kwotę (z walutą PLN/EUR/USD/GBP), nazwę oraz opcjonalne daty i opis (max 200 znaków).
* **Spłaty:** Obsługa częściowej spłaty długu. System musi blokować wpisanie kwoty spłaty przekraczającej pozostałe saldo.
* **Przypomnienia:** System wysyła użytkownikowi powiadomienia Push o 19:00 zgodnie z ustawioną logiką cykliczną ("co X dni") lub zbliżającym się terminem. Powiadomienia są automatycznie anulowane po pełnej spłacie.
* **Interfejs:** Listy są rozdzielone na dwie zakładki (Długi/Pożyczki), posortowane według terminu zwrotu. Zakończone transakcje dostępne w zwijanym Archiwum.
* **Wizualne/Techniczne:** Aplikacja musi wspierać Dark Mode i dostosowywać formatowanie walut do ustawień Locale telefonu.

### 🗺️ Kluczowe Historie Użytkownika i Ścieżki

1.  **Szybkie dodawanie pożyczki:** Użytkownik przechodzi do zakładki "Pożyczki" -> Klika FAB -> Wpisuje wymaganą nazwę i kwotę -> Zapisuje.
2.  **Odnotowanie spłaty:** Użytkownik dostaje powiadomienie Push o 19:00 -> Otwiera aplikację -> Klika na zaległy dług -> Wpisuje częściową kwotę spłaty -> Obserwuje pasek postępu.
3.  **Sprawdzanie historii:** Użytkownik przewija listę do dołu -> Rozwija Akordeon Archiwum -> Weryfikuje stare transakcje.

### 📈 Kryteria Sukcesu (KPI)

Mimo braku bezpośredniej dyskusji nad KPI, na podstawie funkcjonalności kluczowe mierniki sukcesu MVP powinny obejmować:

* **Aktywność:** **DAU/MAU** (Daily/Monthly Active Users).
* **Wartość Użytkowa:** **Liczba Długów/Pożyczek Aktywnych** per użytkownik (im więcej, tym większa integracja z życiem).
* **Wskaźnik Retencji:** Procent użytkowników, którzy wracają po 7 dniach (D7 Retention), co świadczy o faktycznej użyteczności funkcji przypominania.
* **Ukończone Cykle:** Liczba transakcji oznaczonych jako 100% spłacone.

### ❓ Nierozwiązane Kwestie

* **Wybór lokalnej bazy danych:** Nie ustalono, jakiej konkretnej biblioteki (np. Hive, SQLite) użyje zespół Fluttera do lokalnego zapisu danych. Wpłynie to na architekturę.
* **Walidacja tekstu:** Brak precyzyjnej walidacji dla pola "Nazwa" (oprócz tego, że musi być niepuste), np. minimalna/maksymalna długość znaków.
* **Logika ponownego planowania powiadomień:** Nie ustalono, czy edycja daty zwrotu długu powoduje automatyczne przeplanowanie (reschedule) istniejącego powiadomienia Push.
  \</prd_planning_summary>
  \</conversation_summary>



Oto kompleksowy Dokument Wymagań Produktu (PRD) dla aplikacji "Rejestr Długów i Pożyczek (MVP)".


http://googleusercontent.com/immersive_entry_chip/0
Świetnie! Stworzyłem kompleksowy Dokument Wymagań Produktu (PRD) w języku polskim, zgodnie z Twoimi instrukcjami i przyjętą metodologią.

Plik "dept_loans_prd.md" zawiera:
* Szczegółowy przegląd projektu, problemu użytkownika i granic MVP.
* Kompletną listę Wymagań Funkcjonalnych (FR).
* Pełną listę 10 historyjek użytkowników (US-001 do US-010), zawierającą scenariusze podstawowe, krawędziowe (jak limit spłaty czy ograniczenie opisu) oraz niekonwencjonalne (dostęp lokalny/Dark Mode).
* Wszystkie historyjki użytkownika mają unikalny ID, tytuł, opis i szczegółowe Kryteria Akceptacji.
* Zestaw mierzalnych Metryk Sukcesu (KPI) dla MVP.

Ten dokument jest gotowy do przekazania zespołowi deweloperskiemu i projektowemu. Daj mi znać, jeśli chciałbyś pogłębić analizę któregoś z punktów, na przykład, aby stworzyć makiety interfejsu dla kluczowych historyjek użytkownika!