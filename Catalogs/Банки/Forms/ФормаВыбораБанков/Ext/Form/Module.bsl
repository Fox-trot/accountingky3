﻿
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	ЗаполнитьСуществующие();		
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗаполнитьСписокБанков();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
// Процедура - обработчик события "Выбор" поля ""СписокБанков".
//
Процедура СписокБанковВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтрокаТаблицы = СписокБанков.НайтиПоИдентификатору(ВыбраннаяСтрока);
	СтрокаТаблицы.Выбран = НЕ СтрокаТаблицы.Выбран;
	
КонецПроцедуры // СписокБанковВыбор()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
// Процедура вызывается при нажатии кнопки "Подобрать банки" в локальном режиме работы
//
Процедура ПодобратьБанки()

	ЗаполнитьСписокБанков();
	
КонецПроцедуры // ПодобратьБанкиВыполнить()

&НаКлиенте
// Процедура вызывается при нажатии кнопки "Добавить в справочник".
//
Процедура ДобавитьВСправочник(Команда)
	
	МассивБанков = ДобавитьБанкиВСправочник();
	
	Для Каждого Банк Из МассивБанков Цикл
		
		НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(Банк);
		ПоказатьОповещениеПользователя(НСтр("ru = 'Добавлен новый банк:'"), НавигационнаяСсылка, СокрЛП(Банк));
		
	КонецЦикла;
	
	ОповеститьОВыборе("");
	Оповестить("ОбновитьПослеДобавления");

КонецПроцедуры // ДобавитьВСправочник()

&НаКлиенте
// Процедура вызывается при нажатии на кнопку "Выбрать все".
//
Процедура ВыбратьБанки(Команда)
	
	Для Каждого СтрокаТаблицы Из СписокБанков Цикл
		СтрокаТаблицы.Выбран = Истина;
	КонецЦикла;
	
КонецПроцедуры // ВыбратьБанки()

&НаКлиенте
// Процедура вызывается при нажатии на кнопку "Исключить все".
//
Процедура ИсключитьБанки(Команда)
	
	Для Каждого СтрокаТаблицы Из СписокБанков Цикл
		СтрокаТаблицы.Выбран = Ложь;
	КонецЦикла;
	
КонецПроцедуры // ИсключитьБанки()

&НаКлиенте
// Процедура вызывается при нажатии на кнопку "Выбрать выделенные".
//
Процедура ВыбратьВыделенныеБанки(Команда)
	
	МассивСтрок = Элементы.СписокБанков.ВыделенныеСтроки;
	Для Каждого НомерСтроки Из МассивСтрок Цикл
		СписокБанков.НайтиПоИдентификатору(НомерСтроки).Выбран = Истина;
	КонецЦикла;
	
КонецПроцедуры // ВыбратьВыделенныеБанки()

&НаКлиенте
// Процедура вызывается при нажатии на кнопку "Исключить выделенные".
//
Процедура ИсключитьВыделенныеБанки(Команда)
	
	МассивСтрок = Элементы.СписокБанков.ВыделенныеСтроки;
	Для Каждого НомерСтроки Из МассивСтрок Цикл
		СписокБанков.НайтиПоИдентификатору(НомерСтроки).Выбран = Ложь;
	КонецЦикла;
	
КонецПроцедуры // ИсключитьВыделенныеБанки()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура добовляет условное оформление.
//
&НаСервере
Процедура ЗаполнитьСуществующие()

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Банки.Код КАК Код
		|ИЗ
		|	Справочник.Банки КАК Банки";
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда 
		Возврат;
	КонецЕсли;
	
	// Оформление.
	ЭлементыУсловногоОформленияФормы = ЭтаФорма.УсловноеОформление.Элементы;

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ЭлементУсловногоОформления = ЭлементыУсловногоОформленияФормы.Добавить();
		ЭлементУсловногоОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		ЭлементУсловногоОформления.ИдентификаторПользовательскойНастройки = "Предустановленный";
		ЭлементУсловногоОформления.Представление = НСтр("ru = 'Уже добавлен'");
		
		// Цвет текста.
		ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
		ЭлементЦветаОформления.Значение = ОбщегоНазначенияВызовСервера.ЦветСтиля("НедоступныеДанныеЦвет");
		ЭлементЦветаОформления.Использование = Истина;
		
		// Отбор.		
		ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("СписокБанков.БИК");
		ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Содержит;
		ЭлементОтбораДанных.ПравоеЗначение = ВыборкаДетальныеЗаписи.Код;
		ЭлементОтбораДанных.Использование  = Истина;
		
		// Поля.
		ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить(); 
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("НаименованиеБанка");
		ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить(); 
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("БИКБанка");
		ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить(); 
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("АдресБанка");
		ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить(); 
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("СписокБанковSWIFT");
		ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить(); 
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("СписокБанковИндекс");
	КонецЦикла;
КонецПроцедуры // ЗаполнитьСуществующие()

&НаСервере
// Функция добавляет выбранные банки в справочник "Банки" в режиме сервиса
//
// Возвращаемое значение:
//	Массив - Массив добавленных банков
//
Функция ДобавитьБанкиВЛокальномРежиме()
	
	МассивБанков = Новый Массив;
	
	Для Каждого СтрокаТаблицы Из СписокБанков Цикл
	
		Если СтрокаТаблицы.Выбран Тогда
			
			НайденныйБанк = Справочники.Банки.НайтиПоКоду(СтрокаТаблицы.БИК);
			
			БанкОбъект = ?(ЗначениеЗаполнено(НайденныйБанк), НайденныйБанк.ПолучитьОбъект(), Справочники.Банки.СоздатьЭлемент());
			
			ЗаполнитьЗначенияСвойств(БанкОбъект, СтрокаТаблицы);
			
			БанкОбъект.Код = СтрокаТаблицы.БИК;
			БанкОбъект.Записать();
			
			МассивБанков.Добавить(БанкОбъект.Ссылка);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат МассивБанков;
	
КонецФункции // ДобавитьБанкиВЛокальномРежиме()

&НаСервере
// Процедура заполняет список банков в локальном режиме работы
//
Процедура ЗаполнитьСписокБанков()
	
	РезультатЗапроса = Справочники.Банки.ПолучитьРезультатЗапросаПоКлассификатору(
		БИК,
		КоррСчет,
		Наименование,
		Адрес);
		
	Выборка = РезультатЗапроса.Выбрать();
		
	СписокБанков.Очистить();
	
	КодВместоБИК = (РезультатЗапроса.Колонки.Найти("БИК") = Неопределено);
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = СписокБанков.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
		НоваяСтрока.Наименование = СтрЗаменить(НоваяСтрока.Наименование, """""","""");
		
		Если КодВместоБИК Тогда
			
			НоваяСтрока.БИК = Выборка.Код;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьСписокБанковВЛокальномРежиме()

&НаСервере
// Инициализирует добавление банков
//
//
Функция ДобавитьБанкиВСправочник()
	
	// В свзяи с изменение подсистемы поставляемых данных конструкция:
	//
	// Возврат ДобавитьБанкиВРежимеСервиса();
	//
	// более не актуальна;
	
	Возврат ДобавитьБанкиВЛокальномРежиме();
	
КонецФункции // ДобавитьБанкиВСправочник()

#КонецОбласти


