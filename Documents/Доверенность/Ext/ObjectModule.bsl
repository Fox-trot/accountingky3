﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	Если Товары.Количество() = 0 И ОсновныеСредства.Количество() = 0 Тогда
		ПроверяемыеРеквизиты.Добавить("Товары");
		ПроверяемыеРеквизиты.Добавить("ОсновныеСредства");
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
	Если НЕ ЗначениеЗаполнено(ДатаДействия) Тогда
		ДатаДействия = ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()) + 86400 * 10; // 10 дней
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(БанковскийСчет) Тогда		
		БанковскийСчет = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьОсновнойБанковскийСчетОрганизации(Организация);		
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли