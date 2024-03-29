﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Вставить содержимое обработчика.
	Элементы.Номенклатура.Видимость = НЕ Параметры.Отбор.Свойство("Номенклатура");
	
	// ПодключаемоеОборудование
	ИспользоватьПодключаемоеОборудование = ПодключаемоеОборудованиеБППовтИсп.ИспользоватьПодключаемоеОборудование();
	// Конец ПодключаемоеОборудование

КонецПроцедуры

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
			Если Параметр[ 1 ] = Неопределено Тогда
				ТекКод = Параметр[ 0 ];
			Иначе
				ТекКод = Параметр[ 1 ][ 1 ];
			КонецЕсли;
			Если Не ОбработатьПолученныйШК(ТекКод) Тогда
				ТекстСообщения = НСтр("ru = 'Штрихкод %ШКод% не найден.'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ШКод%", ТекКод);
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры // ОбработкаОповещения()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция производит поиск записи в регистре сведений по измерению Штрихкод
// и позиционируется на ней в списке.
// Результат - структура с ключами "Владелец", "Штрихкод", "ТипШтрихкода".
// Если ключ "Владелец" отсутствует, то запись не найдена.
//
&НаСервере
Функция ОбработатьПолученныйШК(ТекКод)
	
	ВозвращаемоеЗначение = Истина;
	
	Номенклатура = РегистрыСведений.ШтрихкодыНоменклатуры.ПолучитьНоменклатуруПоШтрихкоду(Новый Структура("Штрихкод", ТекКод));
	
	Если ЗначениеЗаполнено(Номенклатура) Тогда 
		Отбор = Новый Структура;
		Отбор.Вставить("Штрихкод", ТекКод);
		КлючЗаписи = РегистрыСведений.ШтрихкодыНоменклатуры.СоздатьКлючЗаписи(Отбор);
		Элементы.Список.ТекущаяСтрока = КлючЗаписи;
	Иначе
		ВозвращаемоеЗначение = Ложь;
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции   

#КонецОбласти