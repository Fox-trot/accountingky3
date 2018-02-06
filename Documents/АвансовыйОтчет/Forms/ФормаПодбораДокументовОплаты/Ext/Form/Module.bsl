﻿
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Дата 									= Параметры.Дата;
	Организация 							= Параметры.Организация;
	УникальныйИдентификаторФормыВладельца 	= Параметры.УникальныйИдентификатор;
	
	Если Параметры.Свойство("АдресВХранилище") Тогда
		АдресВХранилище 	= Параметры.АдресВХранилище;
		ТаблицаИзХранилища 	= ПолучитьИзВременногоХранилища(АдресВХранилище);
		ПодборДокументов(ТаблицаИзХранилища);
	Иначе
		ПодборДокументов();
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СнятьВсеФлажки(Команда)
	Для каждого СтрокаТЗ из ТаблицаДокументов Цикл
		Если СтрокаТЗ.УжеПодобран = Ложь Тогда
			СтрокаТЗ.Подобрать = Ложь;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВсеФлажки(Команда)
	Для каждого СтрокаТЗ из ТаблицаДокументов Цикл
		Если СтрокаТЗ.УжеПодобран = Ложь Тогда
			СтрокаТЗ.Подобрать = Истина;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура Подобрать(Команда)
	АдресЗапасовВХранилище = ЗаписатьПодборВХранилище();
	
	ПараметрыПодбора = Новый Структура;
	ПараметрыПодбора.Вставить("АдресЗапасовВХранилище", АдресЗапасовВХранилище);
	
	Оповестить("ПодборДокументовОплатыПоставщикам", ПараметрыПодбора, УникальныйИдентификаторФормыВладельца);
	
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция помещает результаты подбора в хранилище
//
&НаСервере
Функция ЗаписатьПодборВХранилище() 
	
	ПараметрыОтбора = Новый Структура();
	ПараметрыОтбора.Вставить("Подобрать", Истина);
	ПараметрыОтбора.Вставить("УжеПодобран", Ложь);
	ДанныеТаблицыЗначений = ТаблицаДокументов.НайтиСтроки(ПараметрыОтбора);
	
	Возврат ПоместитьВоВременноеХранилище(ДанныеТаблицыЗначений, УникальныйИдентификаторФормыВладельца);
	
КонецФункции //ЗаписатьПодборВХранилище()

// Процедура подбирает проводки из РБ по всем документам, кроме "Закрыти месяца" 
// по счетам доходов и расходов.
//
// Параметры:
//  ТаблицаИзХранилища  - ТаблицаЗначений - данные ТЧ "ПодобранныеПроводки" из основной формы документа.
//
&НаСервере
Процедура ПодборДокументов(ТаблицаИзХранилища = Неопределено)

	Запрос = Новый Запрос();
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПоступлениеТоваровУслуг.Ссылка КАК ВидДокВходящий,
		|	ПоступлениеТоваровУслуг.Контрагент КАК Контрагент,
		|	ПоступлениеТоваровУслуг.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	ПоступлениеТоваровУслуг.Дата КАК ДатаВходящиегоДокумента,
		|	ПоступлениеТоваровУслуг.Номер КАК НомерВходящиегоДокумента,
		|	СУММА(ТаблицаТовары.Всего) КАК СуммаПоТоварам,
		|	СУММА(ТаблицаУслуги.Всего) КАК СуммаПоУслугам,
		|	СУММА(ТаблицаОС.Всего) КАК СуммаПоОС
		|ПОМЕСТИТЬ ВременнаяТаблицаДокументов
		|ИЗ
		|	Документ.ПоступлениеТоваровУслуг КАК ПоступлениеТоваровУслуг
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПоступлениеТоваровУслуг.Товары КАК ТаблицаТовары
		|		ПО (ТаблицаТовары.Ссылка = ПоступлениеТоваровУслуг.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПоступлениеТоваровУслуг.Услуги КАК ТаблицаУслуги
		|		ПО (ТаблицаУслуги.Ссылка = ПоступлениеТоваровУслуг.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПоступлениеТоваровУслуг.ОС КАК ТаблицаОС
		|		ПО (ТаблицаОС.Ссылка = ПоступлениеТоваровУслуг.Ссылка)
		|ГДЕ
		|	ПоступлениеТоваровУслуг.ПометкаУдаления = ЛОЖЬ
		|	И ПоступлениеТоваровУслуг.Проведен = ИСТИНА
		|	И ПоступлениеТоваровУслуг.Организация = &Организация
		|	И ПоступлениеТоваровУслуг.Дата <= &Дата
		|
		|СГРУППИРОВАТЬ ПО
		|	ПоступлениеТоваровУслуг.Ссылка,
		|	ПоступлениеТоваровУслуг.Контрагент,
		|	ПоступлениеТоваровУслуг.ДоговорКонтрагента,
		|	ПоступлениеТоваровУслуг.Дата,
		|	ПоступлениеТоваровУслуг.Номер
		|;
		|
		|///////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокументов.ВидДокВходящий,
		|   ТаблицаДокументов.Контрагент,
		|   ТаблицаДокументов.ДоговорКонтрагента,
		|   ТаблицаДокументов.ДатаВходящиегоДокумента,
		|   ТаблицаДокументов.НомерВходящиегоДокумента,
		|   ЕСТЬNULL(ТаблицаДокументов.СуммаПоТоварам, 0) + ЕСТЬNULL(ТаблицаДокументов.СуммаПоУслугам, 0) + ЕСТЬNULL(ТаблицаДокументов.СуммаПоОС, 0) КАК Сумма 
		|ИЗ
		|	ВременнаяТаблицаДокументов КАК ТаблицаДокументов";	
	Запрос.УстановитьПараметр("Дата", 			Дата);
	Запрос.УстановитьПараметр("Организация", 	Организация);
	
	Если ТаблицаИзХранилища = Неопределено Тогда
		ТаблицаДокументов.Загрузить(Запрос.Выполнить().Выгрузить());	
	Иначе
		ТЗ = Запрос.Выполнить().Выгрузить();
		
		ТЗ.Колонки.Добавить("Подобрать");
		ТЗ.Колонки.Добавить("УжеПодобран");
		ТЗ.ЗаполнитьЗначения(Ложь, "Подобрать, УжеПодобран");
		
		Для Каждого СтрокаТаблицыЗначений Из ТЗ Цикл
			
			СтруктураОтбора = Новый Структура();
			СтруктураОтбора.Вставить("ВидДокВходящий", СтрокаТаблицыЗначений.ВидДокВходящий);
			
			МассивСтрок = ТаблицаИзХранилища.НайтиСтроки(СтруктураОтбора);
			
			Если МассивСтрок.Количество() > 0 Тогда
				СтрокаТаблицыЗначений.Подобрать = Истина;
				СтрокаТаблицыЗначений.УжеПодобран = Истина;
			КонецЕсли;
			
			НоваяСтрока = ТаблицаДокументов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицыЗначений);
		КонецЦикла;
	КонецЕсли;	

КонецПроцедуры

#КонецОбласти