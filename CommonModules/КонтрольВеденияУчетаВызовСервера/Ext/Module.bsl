﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Для вызова из команды отчета РезультатыПроверкиУчета.
//
Функция ИгнорироватьПроблему(ОтчетДанныеРасшифровки, ТабличныйДокумент, ИндексРасшифровки) Экспорт
	Результат = РасшифровкаВыделеннойЯчейки(ОтчетДанныеРасшифровки, ТабличныйДокумент, ИндексРасшифровки);
	Если Результат = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПроблемныйОбъект", Результат.ПроблемныйОбъект);
	Запрос.УстановитьПараметр("ПравилоПроверки", Результат.ПравилоПроверки);
	Запрос.УстановитьПараметр("ВидПроверки", Результат.ВидПроверки);
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РезультатыПроверкиУчета.ИгнорироватьПроблему КАК ИгнорироватьПроблему
		|ИЗ
		|	РегистрСведений.РезультатыПроверкиУчета КАК РезультатыПроверкиУчета
		|ГДЕ
		|	РезультатыПроверкиУчета.ПроблемныйОбъект = &ПроблемныйОбъект
		|	И РезультатыПроверкиУчета.ПравилоПроверки = &ПравилоПроверки
		|	И РезультатыПроверкиУчета.ВидПроверки = &ВидПроверки";
	Значение = Запрос.Выполнить().Выгрузить()[0].ИгнорироватьПроблему;
	
	КонтрольВеденияУчета.ИгнорироватьПроблему(Результат, Не Значение);
	
	СтрокаНайдена = Ложь;
	Для НомерСтроки = 1 По ТабличныйДокумент.ВысотаТаблицы Цикл
		Для НомерКолонки = 1 По ТабличныйДокумент.ШиринаТаблицы Цикл
			Область = ТабличныйДокумент.Область(НомерСтроки, НомерКолонки, НомерСтроки, НомерКолонки);
			Если Область.Расшифровка <> ИндексРасшифровки Тогда
				Продолжить;
			КонецЕсли;
			СтрокаНайдена = Истина;
			Прервать;
		КонецЦикла;
		Если СтрокаНайдена Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если СтрокаНайдена Тогда
		Для НомерКолонки = 1 По ТабличныйДокумент.ШиринаТаблицы Цикл
			Область = ТабличныйДокумент.Область(НомерСтроки, НомерКолонки, НомерСтроки, НомерКолонки);
			Если Значение Тогда
				ПоследняяСтрока = ТабличныйДокумент.ВысотаТаблицы;
				ЦветТекста = ТабличныйДокумент.Область(ПоследняяСтрока, 1, ПоследняяСтрока, 1).ЦветТекста;
				Если ЦветТекста <> Неопределено Тогда
					Область.ЦветТекста = ЦветТекста;
				КонецЕсли;
			Иначе
				Область.ЦветТекста = ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

// Для вызова из команды отчета РезультатыПроверкиУчета.
//
Функция ДанныеДляИсторииИзмененийОбъекта(ОтчетДанныеРасшифровки, ТабличныйДокумент, ИндексРасшифровки) Экспорт
	Расшифровка = РасшифровкаВыделеннойЯчейки(ОтчетДанныеРасшифровки, ТабличныйДокумент, ИндексРасшифровки);
	Если Расшифровка = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Ссылка", Расшифровка.ПроблемныйОбъект);
	Результат.Вставить("Версионируется", Ложь);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		Результат.Версионируется = МодульВерсионированиеОбъектов.ВключеноВерсионированиеОбъекта(Расшифровка.ПолноеИмяОбъекта);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Для вызова из отчета РезультатыПроверкиУчета.
//
Функция РасшифровкаВыделеннойЯчейки(ОтчетДанныеРасшифровки, ТабличныйДокумент, ИндексРасшифровки) Экспорт
	Если ИндексРасшифровки = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ПроблемныйОбъект");
	Результат.Вставить("ПравилоПроверки");
	Результат.Вставить("ВидПроверки");
	Результат.Вставить("УточнениеПроблемы");
	Результат.Вставить("ПолноеИмяОбъекта");
	
	ДанныеРасшифровки = ПолучитьИзВременногоХранилища(ОтчетДанныеРасшифровки);
	Расшифровка       = ДанныеРасшифровки.Элементы[ИндексРасшифровки].ПолучитьПоля();
	Значение          = Расшифровка[0].Значение;
	ЗначениеЧастями   = СтрРазделить(Значение, ";");
	
	Если ЗначениеЧастями.Количество() <> 5 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ЗначениеЧастями[0]);
	Результат.ПроблемныйОбъект = МенеджерОбъекта.ПолучитьСсылку(Новый УникальныйИдентификатор(ЗначениеЧастями[1]));
	Результат.ПравилоПроверки  = Справочники.ПравилаПроверкиУчета.ПолучитьСсылку(Новый УникальныйИдентификатор(ЗначениеЧастями[2]));
	Результат.ВидПроверки      = Справочники.ВидыПроверок.ПолучитьСсылку(Новый УникальныйИдентификатор(ЗначениеЧастями[3]));
	Результат.УточнениеПроблемы = ЗначениеЧастями[4];
	Результат.ПолноеИмяОбъекта = ЗначениеЧастями[0];
	
	Возврат Результат;
КонецФункции

#КонецОбласти