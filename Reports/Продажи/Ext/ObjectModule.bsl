﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Настройки общей формы отчета подсистемы "Варианты отчетов".

//
// Параметры:
//   Форма - УправляемаяФорма, Неопределено - Форма отчета или форма настроек отчета.
//       Неопределено когда вызов без контекста.
//   КлючВарианта - Строка, Неопределено - Имя предопределенного
//       или уникальный идентификатор пользовательского варианта отчета.
//       Неопределено когда вызов без контекста.
//   Настройки - Структура - см. возвращаемое значение
//       ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	СхемаКомпоновкиДанных = ПолучитьМакет("СхемаКомпоновкиДанных");
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти
	
#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Проверки = Новый Структура("КорректностьПериода", Истина);
	БухгалтерскиеОтчетыВызовСервера.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, Проверки);
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	// Отключаем стандартную обработку, т.к. формировать отчет будем "вручную".
	СтандартнаяОбработка = Ложь;
	БухгалтерскиеОтчетыВызовСервера.ОбработкаСобытияПриКомпоновкеРезультата(ЭтотОбъект, ДокументРезультат, ДанныеРасшифровки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("ПоказательОпределятьСуммуПоОплате", КлючВарианта = "ПродажиПоКонтрагентамПоОплате");
	
	НовыеНастройкиКД.ДополнительныеСвойства.Вставить("ДополнительныеПараметрыОтчета", ПараметрыОтчета);
	
	БухгалтерскиеОтчетыВызовСервера.ПередЗагрузкойНастроекВКомпоновщик(ЭтотОбъект, Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли