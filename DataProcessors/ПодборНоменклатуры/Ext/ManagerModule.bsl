﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция возвращает структуру с параметрами обработки подбора
//
// Используется для кеширования
//
Процедура СтруктураСведенийОДокументе(СтруктураПараметров) Экспорт
	
	СтруктураПараметров = Новый Структура;
	
	Для каждого РеквизитОбработки Из Метаданные.Обработки.ПодборНоменклатуры.Реквизиты Цикл
		
		СтруктураПараметров.Вставить(РеквизитОбработки.Имя);
		
	КонецЦикла;
	
КонецПроцедуры // СтруктураПараметровПодбора()

// Проверяем минимальный уровень заполнение параметров
//
Процедура ПроверитьЗаполнениеПараметров(ПараметрыПодбора, Отказ, НазваниеКорзины) Экспорт
	Перем Ошибки;
	
	СтруктураОбязательныхПараметров = СтруктураОбязательныхПараметров(НазваниеКорзины);
	
	Для каждого ЭлементСтруктуры Из СтруктураОбязательныхПараметров Цикл
		
		ЗначениеПараметров = Неопределено;
		Если НЕ ПараметрыПодбора.Свойство(ЭлементСтруктуры.Ключ, ЗначениеПараметров) Тогда
			
			ТекстОшибки = НСтр("ru = 'Отсутствует обязательный параметр (%1), необходимый для открытия формы подбора Номенклатуры.'");
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ЭлементСтруктуры.Значение);
			
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "", ТекстОшибки, Неопределено);
			
		ИначеЕсли НЕ ЗначениеЗаполнено(ЗначениеПараметров) Тогда
			
			ТекстОшибки = НСтр("ru = 'Неверно заполнен обязательный параметр (%1), необходимый для открытия формы подбора Номенклатуры.'");
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ЭлементСтруктуры.Значение);
			
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "", ТекстОшибки, Неопределено);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры // ПроверитьЗаполнениеПараметров()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает структуру обязательных параметров
//
Функция СтруктураОбязательныхПараметров(НазваниеКорзины)
	
	Если НазваниеКорзины = "КорзинаСписания" ИЛИ НазваниеКорзины = "КорзинаМБПСклад" Тогда
		Возврат Новый Структура("Дата, Организация, Склад, УникальныйИдентификаторФормыВладельца", 
			"Дата",
			"Организация",
			"Склад",
			"Уникальный идентификатор формы владельца");
		
	ИначеЕсли НазваниеКорзины = "КорзинаМБПМОЛ" Тогда
		Возврат Новый Структура("Дата, Организация, ФизЛицо, УникальныйИдентификаторФормыВладельца", 
			"Дата",
			"Организация",
			"ФизЛицо",
			"Уникальный идентификатор формы владельца");	
		
	ИначеЕсли НазваниеКорзины = "КорзинаРеализации" Тогда
		Возврат Новый Структура("Дата, Организация, Склад, ДоговорКонтрагента, УникальныйИдентификаторФормыВладельца", 
			"Дата",
			"Организация",
			"Склад",
			"ДоговорКонтрагента",
			"Уникальный идентификатор формы владельца");
					
	ИначеЕсли НазваниеКорзины = "КорзинаПоступления"  Тогда
		Возврат Новый Структура("Дата, Организация, УникальныйИдентификаторФормыВладельца", 
			"Дата",
			"Организация",
			"Уникальный идентификатор формы владельца");		
	КонецЕсли;
	
КонецФункции // СтруктураОбязательныхПараметров()

#КонецОбласти

#КонецЕсли