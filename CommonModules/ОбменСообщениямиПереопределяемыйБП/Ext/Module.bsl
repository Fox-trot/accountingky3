﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// См. ОбменСообщениямиПереопределяемый.ПолучитьОбработчикиКаналовСообщений.
Процедура ПолучитьОбработчикиКаналовСообщений(Обработчики) Экспорт
	
	// БПКР
	Обработчик = Обработчики.Добавить();
	Обработчик.Канал = "ОбщиеСообщения\ТекстовыеСообщения";
	Обработчик.Обработчик = СообщенияШироковещательныйКаналБП;
	// Конец БПКР
	
КонецПроцедуры

// См. ОбменСообщениямиПереопределяемый.ПолучателиСообщения.
Процедура ПолучателиСообщения(Знач КаналСообщений, Получатели) Экспорт
	
	// БПКР
	Если КаналСообщений = "ОбщиеСообщения\ТекстовыеСообщения" Тогда
		
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ОбменСообщениями.Ссылка КАК Ссылка
		|ИЗ
		|	ПланОбмена.ОбменСообщениями КАК ОбменСообщениями
		|ГДЕ
		|	(НЕ ОбменСообщениями.ПометкаУдаления)";
		
		Запрос = Новый Запрос;
		Запрос.Текст = ТекстЗапроса;
		
		Получатели = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		
	КонецЕсли;
	// Конец БПКР
	
КонецПроцедуры

#КонецОбласти
