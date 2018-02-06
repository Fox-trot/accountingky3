﻿
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Элементы.Номенклатура.ТолькоПросмотр = Параметры.ЗначенияЗаполнения.Свойство("Номенклатура");

	// ПодключаемоеОборудование
	ИспользоватьПодключаемоеОборудование = ПодключаемоеОборудованиеБППовтИсп.ИспользоватьПодключаемоеОборудование();
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры // ПриСозданииНаСервере()

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода");
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры // ПриОткрытии()

// Процедура - обработчик события ПриЗакрытии.
//
&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры // ПриЗакрытии()

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование"
	   И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" Тогда
			// Преобразуем предварительно к ожидаемому формату.
			Данные = Новый Массив();
			Если Параметр[1] = Неопределено Тогда
				Данные.Добавить(Новый Структура("Штрихкод, Количество", Параметр[0], 1)); // Достаем штрихкод из основных данных
			Иначе
				Данные.Добавить(Новый Структура("Штрихкод, Количество", Параметр[1][1], 1)); // Достаем штрихкод из дополнительных данных
			КонецЕсли;

			ПолученыШтрихкоды(Данные);
		ИначеЕсли ИмяСобытия = "DataCollectionTerminal" Тогда
			ПолученыШтрихкоды(Параметр);
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры // ОбработкаОповещения()

// Процедура - обработчик события ОбработкаПроверкиЗаполненияНаСервере.
//
&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ШтрихкодыНоменклатуры.Штрихкод КАК Штрихкод,
		|	ШтрихкодыНоменклатуры.Номенклатура КАК Номенклатура,
		|	ПРЕДСТАВЛЕНИЕ(ШтрихкодыНоменклатуры.Номенклатура) КАК НоменклатураПредставление
		|ИЗ
		|	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
		|ГДЕ
		|	ШтрихкодыНоменклатуры.Штрихкод = &Штрихкод";
	Запрос.УстановитьПараметр("Штрихкод", Запись.Штрихкод);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() // Штрихкод уже записан в БД
	   И Запись.ИсходныйКлючЗаписи.Штрихкод <> Запись.Штрихкод Тогда
		ОписаниеОшибки = СтрШаблон(НСтр("ru='Такой штрихкод уже назначен для номенклатуры %1'"), Выборка.НоменклатураПредставление);
		БухгалтерскийУчетСервер.СообщитьОбОшибке(ЭтаФорма, ОписаниеОшибки, , , "Запись.Штрихкод", Отказ);
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроверкиЗаполненияНаСервере()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует штрихкод EAN13.
//
&НаСервереБезКонтекста
Функция СформироватьШтрихкодEAN13()
	
	Возврат РегистрыСведений.ШтрихкодыНоменклатуры.СформироватьШтрихкодEAN13();
	
КонецФункции // СформироватьШтрихкодEAN13()

// ПодключаемоеОборудование
&НаКлиенте
Функция ПолученыШтрихкоды(ДанныеШтрикодов)
	
	Модифицированность = Истина;
	
	Если ДанныеШтрикодов.Количество() > 0 Тогда
		Запись.Штрихкод = ДанныеШтрикодов[ДанныеШтрикодов.Количество() - 1].Штрихкод;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции // ПолученыШтрихкоды()
// Конец ПодключаемоеОборудование

// Процедура обработчик команды НовыйШтрихкод.
//
&НаКлиенте
Процедура НовыйШтрихкод(Команда)
	Запись.Штрихкод = СформироватьШтрихкодEAN13();
КонецПроцедуры

#КонецОбласти