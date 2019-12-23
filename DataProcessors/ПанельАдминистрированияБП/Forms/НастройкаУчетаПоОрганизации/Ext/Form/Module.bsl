﻿
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	КонстантаЗначение = НаборКонстант.ФункциональнаяОпцияУчетПоНесколькимОрганизациям;
	ЗначениеПриОткрытииИспользоватьНесколькоОрганизаций = КонстантаЗначение;
	
КонецПроцедуры // ПриОткрытии()

// Процедура - обработчик события ПередЗаписьюНаСервере формы.
//
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Если присутствуют ссылки на организацию, неравную основной организации, то нельзя снять флаг ИспользоватьНесколькоОрганизаций.
	Если Константы.ФункциональнаяОпцияУчетПоНесколькимОрганизациям.Получить() <> НаборКонстант.ФункциональнаяОпцияУчетПоНесколькимОрганизациям
		И (НЕ НаборКонстант.ФункциональнаяОпцияУчетПоНесколькимОрганизациям) 
		И ОтказСнятиеУчетПоНесколькимОрганизациям() Тогда
		
		НаборКонстант.ФункциональнаяОпцияУчетПоНесколькимОрганизациям = Истина;
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
КонецПроцедуры // ПередЗаписьюНаСервере()

// Процедура - обработчик события ПослеЗаписи формы.
//
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	КонстантаЗначение = НаборКонстант.ФункциональнаяОпцияУчетПоНесколькимОрганизациям;
	Если ЗначениеПриОткрытииИспользоватьНесколькоОрганизаций <> КонстантаЗначение Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура("Значение", КонстантаЗначение), "ФункциональнаяОпцияУчетПоНесколькимОрганизациям");
	КонецЕсли;
	
КонецПроцедуры // ПослеЗаписи()

// Процедура - обработчик события ПослеЗаписиНаСервере.
//
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	КонстантаЗначение = НаборКонстант.ФункциональнаяОпцияУчетПоНесколькимОрганизациям;
	Если ЗначениеПриОткрытииИспользоватьНесколькоОрганизаций <> КонстантаЗначение Тогда
		Константы.НеВестиУчетПоОрганизациям.Установить(Не КонстантаЗначение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ИспользоватьНесколькоОрганизаций.
//
&НаКлиенте
Процедура ФункциональнаяОпцияУчетПоНесколькимОрганизациямПриИзменении(Элемент)	
	ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры // ФункциональнаяОпцияУчетПоНесколькимОрганизациямПриИзменении()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверка на возможность снятия опции УчетПоНесколькимОрганизациям.
//
&НаСервере
Функция ОтказСнятиеУчетПоНесколькимОрганизациям()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Отказ = Ложь;
	
	ОсновнаяОрганизация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	
	ВыборкаОрганизации = Справочники.Организации.Выбрать();
	Пока ВыборкаОрганизации.Следующий() Цикл
		
		Если ВыборкаОрганизации.Ссылка <> ОсновнаяОрганизация Тогда
			
			МассивСсылок = Новый Массив;
			МассивСсылок.Добавить(ВыборкаОрганизации.Ссылка);
			ТаблицаСсылок = НайтиПоСсылкам(МассивСсылок);
			
			Если ТаблицаСсылок.Количество() > 0 Тогда
				
				ТекстСообщения = НСтр("ru = 'В базе используются организации, отличные от основной. Снятие опции запрещено.'");
				БухгалтерскийУчетСервер.СообщитьОбОшибке(ЭтаФорма, ТекстСообщения, , , "НаборКонстант.ФункциональнаяОпцияУчетПоНесколькимОрганизациям", Отказ);
				Прервать;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Отказ;
	
КонецФункции // ОтказСнятиеУчетПоНесколькимОрганизациям()

#КонецОбласти