﻿
#Область ОбработчикиСобытийФормы
    
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    
    Обработки.ИнтерфейсСервиса.ПроверитьВерсиюИнтерфейса(5, Отказ);
    Если Отказ Тогда
        Возврат;
    КонецЕсли; 
    
    ЗаполнитьСписокПользователей();
    
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовТаблицыФормыПользователиАбонента
    
&НаКлиенте
Процедура ПользователиАбонентаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
    
    СтандартнаяОбработка = Ложь;
    ОткрытьЭлемент();
    
КонецПроцедуры

&НаКлиенте
Процедура ПользователиАбонентаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
    
    Отказ = Истина;
    Оповещение = Новый ОписаниеОповещения("ПослеДобавленияИзменения", ЭтотОбъект);
     
    ОткрытьФорму("Обработка.ИнтерфейсСервиса.Форма.ДобавлениеПользователя",, ЭтаФорма,,,, Оповещение);
    
КонецПроцедуры

&НаКлиенте
Процедура ПользователиАбонентаПередНачаломИзменения(Элемент, Отказ)

    Отказ = Истина;
    ОткрытьЭлемент();
    
КонецПроцедуры

&НаКлиенте
Процедура ПользователиАбонентаПередУдалением(Элемент, Отказ)
    
    Отказ = Истина;
    
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы
    
&НаКлиенте
Процедура Обновить(Команда)
    
    КлючТекущейСтроки = "";
    Если Элементы.ПользователиАбонента.ТекущиеДанные <> Неопределено Тогда
        КлючТекущейСтроки = Элементы.ПользователиАбонента.ТекущиеДанные.Логин
    КонецЕсли; 
    ЗаполнитьСписокПользователей(КлючТекущейСтроки);
    
КонецПроцедуры
 
#КонецОбласти 

#Область СлужебныеПроцедурыИФункции
    
&НаСервере
Процедура ЗаполнитьСписокПользователей(КлючТекущейСтроки = "")
	
    ПользователиАбонента.Загрузить(ПрограммныйИнтерфейсСервиса.ПользователиАбонента());
    
    // В качестве ключа текущей строки выступает логин (имя пользователя).
    Если КлючТекущейСтроки <> 0 Тогда
        Поиск = ПользователиАбонента.НайтиСтроки(Новый Структура("Логин", КлючТекущейСтроки));
        Если Поиск.Количество() > 0 Тогда
            Элементы.ПользователиАбонента.ТекущаяСтрока = Поиск[0].ПолучитьИдентификатор();
        КонецЕсли; 
    КонецЕсли;
    	
КонецПроцедуры

&НаКлиенте
Процедура ПослеДобавленияИзменения(Результат, ДопПараметры) Экспорт
	
    Если ТипЗнч(Результат) = Тип("Структура") И Результат.Результат = Истина Тогда
        ЗаполнитьСписокПользователей(Результат.Логин);
    КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЭлемент()
    
    ТекущиеДанные = Элементы.ПользователиАбонента.ТекущиеДанные;
    ПараметрыФормы = Новый Структура("Логин", ТекущиеДанные.Логин);
    Оповещение = Новый ОписаниеОповещения("ПослеДобавленияИзменения", ЭтотОбъект);
    ОткрытьФорму("Обработка.ИнтерфейсСервиса.Форма.Пользователь", ПараметрыФормы, ЭтаФорма,,,, Оповещение);

КонецПроцедуры

#КонецОбласти 
