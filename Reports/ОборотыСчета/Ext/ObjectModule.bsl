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
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ (СальдоНаКонецДт
		ИЛИ СальдоНаКонецКт
		ИЛИ СальдоНаНачалоДт
		ИЛИ СальдоНаНачалоКт
		ИЛИ ОборотыЗаПериодДт
		ИЛИ ОборотыЗаПериодКт
		ИЛИ ОборотыСоСчетамиДт
		ИЛИ ОборотыСоСчетамиКт) Тогда
		
		ТекстСообщения = НСтр("ru = 'Не указаны выводимые данные'");
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Отчет.СальдоНаНачалоДт",, Отказ);
		
	КонецЕсли;
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ);
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаПроверкиЗаполненияОтборов(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли