﻿// По стандартам 1С (http://its.1c.ru/db/v8std#content:-2145783192:hdoc:)
// оформление модулей объектов выглядит так:
//
// #Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
//
// #Область ОписаниеПеременных
// Перем НоваяПеременная;
// #КонецОбласти
//
// #Область ПрограммныйИнтерфейс
// //Код процедур и функций
// #КонецОбласти
//
// #Область ЗаполненияДокумента
// //Код процедур
// #КонецОбласти
//
// #Область ОбработчикиСобытий
// //Код процедур и функций
// #КонецОбласти
//
// #Область СлужебныеПроцедурыИФункции
// //Код процедур и функций
// #КонецОбласти
//
// #КонецЕсли
//
// •Раздел «Описание переменных» содержит переменные модуля. Все переменные модуля должны быть снабжены комментарием, 
// 		достаточным для понимания их назначения. Комментарий рекомендуется размещать в той же строке, где объявляется переменная.
//		Пример:
//		Перем ВалютаУчета; // Валюта, в которой ведется управленческий учет.
//   	Перем АдресПоддержки; // Адрес электронной почты, куда направляются сообщения об ошибках.
//
// •Раздел «Программный интерфейс» содержит экспортные процедуры и функции, предназначенные для использования 
// 		в других модулях конфигурации или другими программами (например, через внешнее соединение). 
// 		Не следует в этот раздел помещать экспортные функции и процедуры, которые предназначены для вызова исключительно 
// 		из модулей самого объекта, его форм и команд. Например, процедуры заполнения табличной части документа, 
// 		которые вызываются из обработки заполнения в модуле объекта и из формы документа в обработчике команды формы 
// 		не являются программным интерфейсом модуля объекта, т.к. вызываются только в самом модуле и из форм этого же объекта. 
// 		Их следует размещать в разделе «Служебные процедуры и функции».
//
// •Раздел «Заполнения документа» содержит процедуры для заполнения документа на основании других документов.
//		Как правило определить количество и названия процедур в данной области можно из соответствия "СтратегияЗаполнения" 
//		в процедуре "ОбработкаЗаполнения", которая расположена в модуле объекта, область "ОбработчикиСобытий".
//		Но есть исключения, например, в модулях объектов документов "ПлатежноеПоручениеИсходящее" или "РасходныйКассовыйОрдер".
//		Соответственно данная область применима только для модулей объектов документов.
//
// •Раздел «Обработчики событий» содержит обработчики событий модуля объекта (ПриЗаписи, ПриПроведении и др.)
//
// •Раздел «Служебные процедуры и функции» имеет такое же предназначение, как и в общих модулях.

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.ПриемНаРаботу.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьХозрасчетный(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей.
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль
	ВыполнитьКонтроль(ДополнительныеСвойства, Отказ);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
КонецПроцедуры // ОбработкаПроведения()

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для удаления проведения документа
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	// Проверка заполнения табличных частей
	ПроверяемыеРеквизиты.Добавить("Товары");

	//// Проверка заполнения Скидки/Наценки
	//Если НЕ ЗначениеЗаполнено(ВидСкидкиНаценки) Тогда 
	//	МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаСкидок");
	//КонецЕсли;	

	//Если Курс = 0 Или Кратность = 0 Тогда 
	//	ТекстСообщения = НСтр("ru = 'Не заполнен курс валюты ""%1"". Откройте список валют (Банк и касса - Валюты) и проверьте,
	//		|что у валюты ""%1"" установлен курс на дату %2 или ранее.
	//		|Перевыберите договор и заново проведите документ.'");
	//	ТекстСообщения = СтрШаблон(ТекстСообщения, ВалютаДокумента, Формат(Дата, "ДЛФ=D"));	
	//	
	//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
	//КонецЕсли;

	ОбщегоНазначенияБПСервер.ДобавитьНепроверяемыеРеквизитыПоПараметрамФункциональныхОпций(МассивНепроверяемыхРеквизитов, Организация, Дата);
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	// Выполнение предварительного контроля.
	ВыполнитьПредварительныйКонтроль(Отказ);
КонецПроцедуры

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

// Выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;	
КонецПроцедуры

// Выполняет контроль противоречий.
//
Процедура ВыполнитьКонтроль(ДополнительныеСвойства, Отказ)
	Если Отказ Тогда
		Возврат;	
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли