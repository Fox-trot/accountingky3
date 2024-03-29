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
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗагрузитьКлассификаторТаблицаНаКлиенте();
	ЗаполнитьСписокБанков();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события "Выбор" поля ""СписокБанков".
//
&НаКлиенте
Процедура СписокБанковВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтрокаТаблицы = СписокБанков.НайтиПоИдентификатору(ВыбраннаяСтрока);
	СтрокаТаблицы.Выбран = НЕ СтрокаТаблицы.Выбран;
	
КонецПроцедуры // СписокБанковВыбор()

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура вызывается при нажатии кнопки "Подобрать банки" в локальном режиме работы
//
&НаКлиенте
Процедура ПодобратьБанки()
	ЗаполнитьСписокБанков();
КонецПроцедуры // ПодобратьБанкиВыполнить()

// Процедура вызывается при нажатии кнопки "Добавить в справочник".
//
// Параметры:
//  Команда	 - 	 - 
//
&НаКлиенте
Процедура ДобавитьВСправочник(Команда)
	
	МассивБанков = ДобавитьБанкиВСправочник();
	
	Для Каждого Банк Из МассивБанков Цикл
		
		НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(Банк);
		ПоказатьОповещениеПользователя(НСтр("ru = 'Добавлен новый банк:'"), НавигационнаяСсылка, СокрЛП(Банк));
		
	КонецЦикла;
	
	ОповеститьОВыборе("");
	Оповестить("ОбновитьПослеДобавления");

КонецПроцедуры // ДобавитьВСправочник()

// Процедура вызывается при нажатии на кнопку "Выбрать все".
//
// Параметры:
//  Команда	 - 	 - 
//
&НаКлиенте
Процедура ВыбратьБанки(Команда)
	
	Для Каждого СтрокаТаблицы Из СписокБанков Цикл
		СтрокаТаблицы.Выбран = Истина;
	КонецЦикла;
	
КонецПроцедуры // ВыбратьБанки()

// Процедура вызывается при нажатии на кнопку "Исключить все".
//
&НаКлиенте
Процедура ИсключитьБанки(Команда)
	
	Для Каждого СтрокаТаблицы Из СписокБанков Цикл
		СтрокаТаблицы.Выбран = Ложь;
	КонецЦикла;
	
КонецПроцедуры // ИсключитьБанки()

// Процедура вызывается при нажатии на кнопку "Выбрать выделенные".
//
&НаКлиенте
Процедура ВыбратьВыделенныеБанки(Команда)
	
	МассивСтрок = Элементы.СписокБанков.ВыделенныеСтроки;
	Для Каждого НомерСтроки Из МассивСтрок Цикл
		СписокБанков.НайтиПоИдентификатору(НомерСтроки).Выбран = Истина;
	КонецЦикла;
	
КонецПроцедуры // ВыбратьВыделенныеБанки()

// Процедура вызывается при нажатии на кнопку "Исключить выделенные".
//
&НаКлиенте
Процедура ИсключитьВыделенныеБанки(Команда)
	
	МассивСтрок = Элементы.СписокБанков.ВыделенныеСтроки;
	Для Каждого НомерСтроки Из МассивСтрок Цикл
		СписокБанков.НайтиПоИдентификатору(НомерСтроки).Выбран = Ложь;
	КонецЦикла;
	
КонецПроцедуры // ИсключитьВыделенныеБанки()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура настройки условного оформления форм и динамических списков .
//
&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// Таблица СписокБанков.
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("СписокБанков");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокБанков.БИК");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Содержит;
	ОтборЭлемента.ПравоеЗначение = "001";

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветПодписи);
	
КонецПроцедуры

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
	ЭлементыУсловногоОформленияФормы = УсловноеОформление.Элементы;

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

// Функция добавляет выбранные банки в справочник "Банки" в режиме сервиса
//
// Возвращаемое значение:
//	Массив - Массив добавленных банков
//
&НаСервере
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

// Процедура заполняет список банков в локальном режиме работы
//
&НаСервере
Процедура ЗаполнитьСписокБанков()
	
	РезультатЗапроса = ПолучитьДанныеИзКлассификатора(
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

// Функция формирует результат запроса по классификатору банков
// с отбором по Код, корреспондентскому счету, наименованию банка, Адресу
//
// - разделение даных включено, источником данных выступает справочник классификатор банков
// - разделение даных не включено, источником данных выступает макет, приложенный к справочнику банков
//
// Параметры:
//	Код - Строка (9) - Код банка
//	КорСчет - Строка (20) - Корреспондентский счет банка
//
// Возвращаемое значение:
//	РезультатЗапроса - Результат запроса по классификатору.
//
&НаСервере
Функция ПолучитьДанныеИзКлассификатора(БИК, КоррСчет, Наименование, Адрес)
	
	Построитель = Новый ПостроительЗапроса;
	Построитель.ИсточникДанных = Новый ОписаниеИсточникаДанных(КлассификаторТаблица.Выгрузить());
	
	ИмяПоляБИК = "БИК";
	
	ДобавитьЭлементОтбораПостроителяОтбора(Построитель, ИмяПоляБИК, СокрЛП(БИК), ВидСравнения.Содержит);
	ДобавитьЭлементОтбораПостроителяОтбора(Построитель, "КоррСчет", СокрЛП(КоррСчет), ВидСравнения.Содержит);
	ДобавитьЭлементОтбораПостроителяОтбора(Построитель, "Наименование", СокрЛП(Наименование), ВидСравнения.Содержит);
	ДобавитьЭлементОтбораПостроителяОтбора(Построитель, "Адрес", СокрЛП(Адрес), ВидСравнения.Содержит);
	
	Построитель.Выполнить();
	
	Возврат Построитель.Результат;
	
КонецФункции // ПолучитьРезультатЗапросаПоКлассификаторуВРазделенномРежиме()

// Процедура - Загрузить классификатор таблица
//
&НаСервере
Процедура ЗагрузитьКлассификаторТаблица(ОписаниеОшибки)
	
	РеквизитыКлассификаторБанков = РаботаСКонтрагентами.РеквизитыКлассификаторБанков();
	
	Если ЗначениеЗаполнено(РеквизитыКлассификаторБанков.ОписаниеОшибки) Тогда
		ОписаниеОшибки = РеквизитыКлассификаторБанков.ОписаниеОшибки;
		Возврат;
	КонецЕсли;
	
	// Получение из XML.
	КлассификаторXML = РеквизитыКлассификаторБанков.КлассификаторXML;
	КлассификаторТаблица.Загрузить(ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные);
	
КонецПроцедуры 

// Добавить элемент отбора построителя отчета
//
&НаСервере
Процедура ДобавитьЭлементОтбораПостроителяОтбора(Построитель, Имя, Значение, ЗначениеВидаСравнения)
	
	Если ЗначениеЗаполнено(Значение) Тогда
		
		ЭлементОтбора = Построитель.Отбор.Добавить(Имя);
		
	Иначе
		
		Возврат;
		
	КонецЕсли;
	
	ЭлементОтбора.ВидСравнения = ЗначениеВидаСравнения;
	ЭлементОтбора.Значение = Значение;
	ЭлементОтбора.Использование = Истина;
	
КонецПроцедуры //ДобавитьЭлементОтбораПостроителяОтбора()

// Инициализирует добавление банков
//
//
&НаСервере
Функция ДобавитьБанкиВСправочник()
	
	// В свзяи с изменение подсистемы поставляемых данных конструкция:
	//
	// Возврат ДобавитьБанкиВРежимеСервиса();
	//
	// более не актуальна;
	
	Возврат ДобавитьБанкиВЛокальномРежиме();
	
КонецФункции // ДобавитьБанкиВСправочник()

// Процедура - Загрузить классификатор таблица
//
&НаКлиенте
Процедура ЗагрузитьКлассификаторТаблицаНаКлиенте()

	Состояние(
		НСтр("ru = 'Получение данных'"),
		,
		НСтр("ru = 'Пожалуйста, подождите...'"));
	ОписаниеОшибки = "";
	ЗагрузитьКлассификаторТаблица(ОписаниеОшибки);
	Состояние();
	
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		
		ОбработчикЗавершенияОбработкиОшибки = Новый ОписаниеОповещения(
			"ОбработатьОшибкуЗагрузитьКлассификаторЗавершение",
			ЭтотОбъект);
		ДополнительныеПараметрыОбработкиОшибки =
			РаботаСКонтрагентамиКлиент.НовыйДополнительныеПараметрыОбработкиОшибки();
		ДополнительныеПараметрыОбработкиОшибки.ПредставлениеДействия    = НСтр("ru = 'Загрузка классификатора банков'");
		ДополнительныеПараметрыОбработкиОшибки.ИдентификаторМестаВызова = "ClassifierBank";
		ДополнительныеПараметрыОбработкиОшибки.Форма                    = ЭтотОбъект;
		
		РаботаСКонтрагентамиКлиент.ОбработатьОшибку(
			ОписаниеОшибки,
			ОбработчикЗавершенияОбработкиОшибки,
			ДополнительныеПараметрыОбработкиОшибки);
			
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура ОбработатьОшибкуЗагрузитьКлассификаторЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.ПовторитьДействие Тогда
		ЗагрузитьКлассификаторТаблицаНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


