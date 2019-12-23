﻿
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Дата = Параметры.Дата;
	
	УстановитьУсловноеОформление();

	// РаботаСФормами
	РаботаСФормамиСервер.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец РаботаСФормами
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода Ведомость.
//
&НаКлиенте
Процедура ВедомостьПриИзменении(Элемент)
	ЗаполнитьТаблицуПоВедомости(Ведомость);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицФормы

// Процедура - обработчик события ПриИзменении поля ввода ТаблицаВыбранных.
//
&НаКлиенте
Процедура ТаблицаВыбранныхПриИзменении(Элемент)
	ЗаполнитьТаблицуПоВедомости(Ведомость)
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоВедомостиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтрокаТаблицыВедомости = Элементы.ТаблицаПоВедомости.ТекущиеДанные;
	Если НЕ СтрокаТаблицыВедомости.УжеВыбран Тогда
		НоваяСтрокаВыбора = ТаблицаВыбранных.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаВыбора, СтрокаТаблицыВедомости);
		НоваяСтрокаВыбора.Ведомость = Ведомость;
		СтрокаТаблицыВедомости.УжеВыбран = Истина;
	КонецЕсли;
	

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	СтруктураВыбора = Новый Структура;
	СтруктураВыбора.Вставить("ВидПодбора", "ПоВедомостиЗП");
	СтруктураВыбора.Вставить("ТаблицаДанных", ТаблицаВыбранных);
	ОповеститьОВыборе(СтруктураВыбора);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура настройки условного оформления форм и динамических списков .
//
&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// Таблица документов.
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ТаблицаПоВедомости");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаДокументов.УжеВыбран");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НедоступныеДанныеЦвет);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуПоВедомости(Ведомость)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаВыбранных.ФизЛицо,
		|	ТаблицаВыбранных.Ведомость
		|ПОМЕСТИТЬ ВременнаяТаблицаУжеВыбранных
		|ИЗ
		|	&ТаблицаВыбранных КАК ТаблицаВыбранных
		|ГДЕ
		|	ТаблицаВыбранных.Ведомость = &Ведомость
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВыплаченнаяЗарплатаОбороты.ФизЛицо,
		|	ВыплаченнаяЗарплатаОбороты.СуммаОборот КАК СуммаКВыплате,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаУжеВыбранных.ФизЛицо ЕСТЬ NULL 
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК УжеВыбран
		|ИЗ
		|	РегистрНакопления.ВыплаченнаяЗарплата.Обороты(, &Дата, , ) КАК ВыплаченнаяЗарплатаОбороты //Ведомость = &Ведомость
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаУжеВыбранных КАК ВременнаяТаблицаУжеВыбранных
		|		ПО ВыплаченнаяЗарплатаОбороты.ФизЛицо = ВременнаяТаблицаУжеВыбранных.ФизЛицо";
	
	Запрос.УстановитьПараметр("Ведомость", Ведомость);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("ТаблицаВыбранных", ТаблицаВыбранных.Выгрузить());
	
	ТаблицаПоВедомости.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры // ЗаполнитьТаблицуПоВедомости()

#КонецОбласти