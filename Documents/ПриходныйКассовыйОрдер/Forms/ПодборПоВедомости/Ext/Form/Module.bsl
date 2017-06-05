﻿
&НаКлиенте
Процедура ВедомостьПриИзменении(Элемент)
	ЗаполнитьТаблицуПоВедомости(Ведомость);
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
		|	ВыплаченнаяЗарплатаОбороты.Физлицо,
		|	ВыплаченнаяЗарплатаОбороты.СуммаОборот КАК СуммаКВыплате,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаУжеВыбранных.ФизЛицо ЕСТЬ NULL 
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК УжеВыбран
		|ИЗ
		|	РегистрНакопления.ВыплаченнаяЗарплата.Обороты(, &Дата, , Ведомость = &Ведомость) КАК ВыплаченнаяЗарплатаОбороты
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаУжеВыбранных КАК ВременнаяТаблицаУжеВыбранных
		|		ПО ВыплаченнаяЗарплатаОбороты.Физлицо = ВременнаяТаблицаУжеВыбранных.ФизЛицо";
	
	Запрос.УстановитьПараметр("Ведомость", Ведомость);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("ТаблицаВыбранных", ТаблицаВыбранных.Выгрузить());
	
	ТаблицаПоВедомости.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры // ЗаполнитьТаблицуПоВедомости()

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Дата = Параметры.Дата;
КонецПроцедуры

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

&НаКлиенте
Процедура Выбрать(Команда)
	СтруктураВыбора = Новый Структура;
	СтруктураВыбора.Вставить("ВидПодбора", "ПоВедомостиЗП");
	СтруктураВыбора.Вставить("ТаблицаДанных", ТаблицаВыбранных);
	ОповеститьОВыборе(СтруктураВыбора);
КонецПроцедуры
