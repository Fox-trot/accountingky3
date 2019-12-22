﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ГруппаФискальныеДанные.Видимость = Объект.ФискальноеУстройство.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККТ;
	Элементы.ПолныеФискальныеДанные.Видимость = Не Объект.Статус = Перечисления.СтатусыКассовойСмены.Открыта;
	Элементы.ФормаЗакрытьСмену.Доступность = Объект.Статус = Перечисления.СтатусыКассовойСмены.Открыта;
	Элементы.ПолныеФискальныеДанные.Видимость = ДоступныВсеФискальныеДанные;
	
	КассовыеСменыПереопределяемый.ФормаДокументаПриСозданииНаСервере(ЭтотОбъект);
	
	// РаботаСФормами
	РаботаСФормамиСервер.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец РаботаСФормами
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	XMLСтрока = ТекущийОбъект.ФДОЗакрытииСмены.Получить();
	Если XMLСтрока = Неопределено Или Не ТипЗнч(XMLСтрока) = Тип("Строка") Или XMLСтрока = "" Тогда
		ДоступныВсеФискальныеДанные = Ложь;
	Иначе
		ДоступныВсеФискальныеДанные = Истина;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменений
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменений

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом 
	
КонецПроцедуры

// Процедура - обработчик события ПослеЗаписиНаСервере.
//
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)	
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПолныеФискальныеДанные(Команда)
	
	ПараметрыОткрытияВсехДанных = Новый Структура();
	ПараметрыОткрытияВсехДанных.Вставить("КассоваяСмена", Объект.Ссылка);
	
	ОткрытьФорму("Документ.КассоваяСмена.Форма.ФормаФискальныхДанных", ПараметрыОткрытияВсехДанных,,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	КассовыеСменыКлиентПереопределяемый.ФормаДокументаВыполнитьПереопределяемуюКоманду(Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗакрытьСмену(Команда)
	
	Если Модифицированность Тогда
		
		ТекстВопроса = НСтр("ru = 'Перед закрытием смены документ будет записан. Продолжить?'");
		ОписаниеОтвета = Новый ОписаниеОповещения("ЗакрытьСменуПослеПодтвержденияЗаписи", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОтвета, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ЗакрытьСменуВыполнить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьСменуПослеПодтвержденияЗаписи(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ЗакрытьСменуВыполнить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьСменуВыполнить()
	
	ПараметрыОперации = МенеджерОборудованияКлиентСервер.ПараметрыОткрытияЗакрытияСмены();
	
	Кассир = "";
	СтандартнаяОбработка = Истина;
	КассовыеСменыКлиентПереопределяемый.ОбработкаЗаполненияИмяКассира(Объект, Кассир, СтандартнаяОбработка); 
	ПараметрыОперации.Кассир = ?(Не СтандартнаяОбработка, Кассир, НСтр("ru='Администратор'")); 
	
	ОповещениеЗакрытия = Новый ОписаниеОповещения("ЗакрытьСменуПослеЗакрытияСмены", ЭтотОбъект);
	
	МенеджерОборудованияКлиент.НачатьЗакрытиеСменыНаФискальномУстройстве(ОповещениеЗакрытия, 
		УникальныйИдентификатор, 
		ПараметрыОперации,
		Объект.ФискальноеУстройство,
		,
		Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьСменуПослеЗакрытияСмены(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия.Результат Тогда
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Кассовая смена закрыта'")
			,
			,
			,
			БиблиотекаКартинок.ВыполнитьЗадачу);
		
		Прочитать();
		Элементы.ФормаЗакрытьСмену.Доступность = Ложь;
		
	Иначе
		
			ПоказатьОповещениеПользователя(
			НСтр("ru = 'Ошибка закрытия кассовой смены'")
			,
			,
			РезультатЗакрытия.ОписаниеОшибки,
			БиблиотекаКартинок.Удалить);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
