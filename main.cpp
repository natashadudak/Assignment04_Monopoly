/*
Name:Natasha Dudak
Course:CS 210
Assignment:Assignment 04: Circular Linked List Monopoly
Professor:Dominic Dabish

Another source of information:
•Youtube video:https://www.youtube.com/watch?v=N6dOwBde7-M
•Youtube video:https://www.youtube.com/watch?v=BBpAmxU_NQo
•Youtube video:https://www.youtube.com/watch?v=HMkdlu5sP4A&list=PLBlnK6fEyqRjW4jK-CbshJuX20nc_3IaN
•Youtube video:https://www.youtube.com/watch?v=LyuuqCVkP5I&list=PLGjplNEQ1it-OKRcYlCEDpTiIB1YOcvn6
•Zbook's book
•Chatgpt: Portuguese-to-English translation, C++ questions, help with the code bug and code review

Date last modified: 10-02-2026
*/

#include <iostream>
#include <string>

using namespace std;

// Each node represents one country/property on the Monopoly board
struct Node {
    string name;
    int cost;
    string owner;
    Node* next;

    Node(string countryName, int countryCost) {
        name = countryName;
        cost = countryCost;
        owner = "Unowned";
        next = nullptr;
    }
};

// Creates and controls the circular linked list
class CircularLinkedList {
private:
    Node* head;
    Node* tail;
    int size;

public:
    CircularLinkedList() {
        head = nullptr;
        tail = nullptr;
        size = 0;
    }

    // Adds a new country to the board
    void add(string name, int cost) {
        Node* newNode = new Node(name, cost);

        // First node
        if (head == nullptr) {
            head = newNode;
            tail = newNode;
            newNode->next = head;
        }
        else {
            tail->next = newNode;
            tail = newNode;

            // Makes the linked list circular
            tail->next = head;
        }

        size++;
    }

    // Searches for a country using its name
    Node* search(string name) {
        if (head == nullptr) {
            return nullptr;
        }

        Node* current = head;

        do {
            if (current->name == name) {
                return current;
            }

            current = current->next;

        } while (current != head);

        return nullptr;
    }

    // Removes a country from the linked list
    bool remove(string name) {
        if (head == nullptr) {
            return false;
        }

        Node* current = head;
        Node* previous = tail;

        do {
            if (current->name == name) {

                // If there is only one node
                if (current == head && current == tail) {
                    head = nullptr;
                    tail = nullptr;
                }
                else {
                    previous->next = current->next;

                    // Removing the first node
                    if (current == head) {
                        head = current->next;
                    }

                    // Removing the last node
                    if (current == tail) {
                        tail = previous;
                    }

                    // Keeps the list circular
                    tail->next = head;
                }

                delete current;
                size--;

                return true;
            }

            previous = current;
            current = current->next;

        } while (current != head);

        return false;
    }

    // Prints all countries on the board one time
    void print() {
        if (head == nullptr) {
            cout << "The board is empty." << endl;
            return;
        }

        Node* current = head;

        do {
            cout << current->name
                 << " | Cost: $" << current->cost
                 << " | Owner: " << current->owner
                 << endl;

            current = current->next;

        } while (current != head);
    }

    // Moves a player through the board
    Node* move(Node* currentPosition, int spaces) {
        if (currentPosition == nullptr) {
            return head;
        }

        for (int i = 0; i < spaces; i++) {
            currentPosition = currentPosition->next;
        }

        return currentPosition;
    }

    Node* getHead() {
        return head;
    }

    int getSize() {
        return size;
    }

    // Deletes the nodes when the program is finished
    ~CircularLinkedList() {
        if (head == nullptr) {
            return;
        }

        // Breaks the circle before deleting everything
        tail->next = nullptr;

        Node* current = head;

        while (current != nullptr) {
            Node* nextNode = current->next;
            delete current;
            current = nextNode;
        }
    }
};

// Information for each player
struct Player {
    string name;
    int money;
    Node* position;

    Player(string playerName, int startingMoney, Node* startingPosition) {
        name = playerName;
        money = startingMoney;
        position = startingPosition;
    }
};

// Tries to buy the country where the player landed
void buyProperty(Player& player) {
    Node* property = player.position;

    // Cannot buy a country that already has an owner
    if (property->owner != "Unowned") {
        cout << property->name
             << " is already owned by "
             << property->owner << "." << endl;

        return;
    }

    // Checks if the player has enough money
    if (player.money < property->cost) {
        cout << player.name
             << " does not have enough money to buy "
             << property->name << "." << endl;

        return;
    }

    // Player buys the property
    property->owner = player.name;
    player.money -= property->cost;

    cout << player.name
         << " bought " << property->name
         << " for $" << property->cost << "." << endl;

    cout << player.name
         << " now has $" << player.money
         << "." << endl;
}

int main() {

    cout << "============================================" << endl;
    cout << " World Monopoly - Circular Linked List" << endl;
    cout << "============================================" << endl << endl;

    CircularLinkedList board;

    // Ten countries on the Monopoly board
    board.add("Brazil", 60);
    board.add("Spain", 80);
    board.add("Mexico", 100);
    board.add("Italy", 120);
    board.add("France", 140);
    board.add("Poland", 160);
    board.add("Germany", 180);
    board.add("United States", 200);
    board.add("Japan", 220);
    board.add("Netherlands", 240);

    // Temporary country to test add, search, and remove
    board.add("Temporary Country", 10);

    cout << "LINKED LIST TEST" << endl;
    cout << "----------------" << endl;

    Node* foundCountry = board.search("Temporary Country");

    if (foundCountry != nullptr) {
        cout << "Search: Temporary Country was found." << endl;
    }
    else {
        cout << "Search: Temporary Country was not found." << endl;
    }

    bool removed = board.remove("Temporary Country");

    if (removed) {
        cout << "Remove: Temporary Country was removed." << endl;
    }
    else {
        cout << "Remove: Temporary Country was not removed." << endl;
    }

    cout << endl;

    // Prints the board before the game starts
    cout << "INITIAL BOARD" << endl;
    cout << "-------------" << endl;

    board.print();

    cout << endl;

    cout << "Number of countries: "
         << board.getSize() << endl << endl;

    // Both players start in Brazil with $1500
    Player natasha("Natasha", 1500, board.getHead());
    Player nicole("Nicole", 1500, board.getHead());

    // Fixed moves so the results are easy to test
    int moves[10] = {2, 2, 4, 3, 4, 5, 3, 3, 6, 1};

    cout << "10 TURN MONOPOLY SIMULATION" << endl;
    cout << "---------------------------" << endl << endl;

    for (int turn = 0; turn < 10; turn++) {

        Player* currentPlayer;

        // Natasha goes first and Nicole goes second
        if (turn % 2 == 0) {
            currentPlayer = &natasha;
        }
        else {
            currentPlayer = &nicole;
        }

        string previousCountry = currentPlayer->position->name;

        // Moves the player
        currentPlayer->position =
            board.move(currentPlayer->position, moves[turn]);

        cout << "Turn " << turn + 1 << ": "
             << currentPlayer->name
             << " moved " << moves[turn]
             << " spaces from " << previousCountry
             << " to " << currentPlayer->position->name
             << "." << endl;

        // Tries to buy the country
        buyProperty(*currentPlayer);

        cout << endl;
    }

    // Shows the owners after the ten turns
    cout << "FINAL BOARD" << endl;
    cout << "-----------" << endl;

    board.print();

    cout << endl;

    cout << "FINAL PLAYER STATUS" << endl;
    cout << "-------------------" << endl;

    cout << natasha.name
         << " has $" << natasha.money
         << " and finished on "
         << natasha.position->name << "." << endl;

    cout << nicole.name
         << " has $" << nicole.money
         << " and finished on "
         << nicole.position->name << "." << endl;

    return 0;
}