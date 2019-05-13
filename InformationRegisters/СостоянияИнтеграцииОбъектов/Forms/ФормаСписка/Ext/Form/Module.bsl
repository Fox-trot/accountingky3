﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    
    Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
    КонецЕсли;
    
    Если Параметры.Отбор.Свойство("УчетнаяСистема") Тогда
        Элементы.УчетнаяСистема.Видимость = Ложь;
        АвтоЗаголовок = Ложь;
        Заголовок = НСтр("ru='Состояния интеграции объектов'"); 
    ИначеЕсли Параметры.Отбор.Свойство("ИдентификаторОбъекта") Тогда
        Элементы.ИдентификаторОбъекта.Видимость = Ложь;    
        АвтоЗаголовок = Ложь;
        Заголовок = НСтр("ru='Состояния интеграции по учетным системам'"); 
    КонецЕсли;

КонецПроцедуры

#КонецОбласти 
