pragma solidity ^0.4.0;
contract YLoyalty {
    
    address public owner; //Владелец контракта
    
    Uchastnik[] public uchastniki;    //Массив всех участников
    Product[] public products;                          //Массив продуктов
    
    struct Uchastnik {
        address addr;               //Адрес кошелька
        bytes name;                 //Имя участника
        uint bals;                  //Баллы
    }
    
    struct Product {
        bytes name;             //Имя продукта
        uint bals;              //Скидка в процентах
    }
    
    function YLoyalty() {
        owner = msg.sender;
    }
    
    function regUser(bytes _name) {
        uchastniki.push(Uchastnik({
            addr: msg.sender,
            name: _name,
            bals: 0
        }));
    }
    
    function addProduct(bytes _name, uint _bals) {
        if (msg.sender == owner) {
            products.push(Product ({
                name: _name,
                bals: _bals
            }));
        }
    }
    
    //Любая транзакция
    function () payable{
        for (uint i = 0; i < uchastniki.length; i++) {
            //Если отправитель транзакции зарегистрирован
            if (uchastniki[i].addr == msg.sender) {
                //Бежим по всем продуктам в программе лояльности
                for (uint j = 0; j < products.length; j++) {
                    //Сравниваем побайтно то, что пришло в транзакции в msg.data
                    //Начинаем с 5 байта, https://ethereum.stackexchange.com/questions/1024/how-to-compare-msg-data-calldata-data-type-to-an-integer-data-type-uint256
                    var f = false;
                    if (msg.data.length == products[j].name.length - 4) {
                        f = true;
                        for (var k = 5; k < msg.data.length; k++) {
                            if (products[j].name[k] != msg.data[k]) {
                                f = false;
                                break;
                            }
                        }
                    }
                    //Нашли продукт
                    if (f) {
                        uchastniki[i].bals +=  products[j].bals;
                        break;
                    }
                }
                break;
            }
        }
    }
    
    function kill()
    { 
        if (msg.sender == owner)
            suicide(owner);
    }
}
