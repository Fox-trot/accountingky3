﻿
#Область ПрограммныйИнтерфейс

// Обработчик события вызывается при получении имени кассира.
//
// Параметры:
//  ИмяКассира - Строка, Неопределено - Текст, используемый для заполнения документа
//  СтандартнаяОбработка - Булево
//
Процедура ОбработкаЗаполненияИмяКассира(ИмяКассира, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Функция возвращает поддерживаемые форматы ФФД в прикладном решении.
//
Функция ПолучитьПоддерживаемыйФорматыФФД() Экспорт
	
	ФорматыФФД = Новый СписокЗначений();
	ФорматыФФД.Добавить("1.0");
	ФорматыФФД.Добавить("1.0.5");
	ФорматыФФД.Добавить("1.1");
	Возврат ФорматыФФД;
	
КонецФункции

#КонецОбласти