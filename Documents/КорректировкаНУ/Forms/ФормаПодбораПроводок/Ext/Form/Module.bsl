﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	НачалоПериода 							= Параметры.НачалоПериода;
	КонецПериода 							= Параметры.КонецПериода;
	Организация 							= Параметры.Организация;
	УникальныйИдентификаторФормыВладельца 	= Параметры.УникальныйИдентификатор;
	
	Если Параметры.Свойство("АдресВХранилище") Тогда
		АдресВХранилище 	= Параметры.АдресВХранилище;
		ТаблицаИзХранилища 	= ПолучитьИзВременногоХранилища(АдресВХранилище);
		ПодборПроводок(ТаблицаИзХранилища);
	Иначе
		ПодборПроводок();
	КонецЕсли;	
			
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Перенести(Команда)
	АдресЗапасовВХранилище = ЗаписатьПодборВХранилище();
	
	ПараметрыПодбора = Новый Структура;
	ПараметрыПодбора.Вставить("АдресЗапасовВХранилище", АдресЗапасовВХранилище);
	
	Оповестить("ПодборПроводокПроизведен", ПараметрыПодбора, УникальныйИдентификаторФормыВладельца);
	
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсеФлажки(Команда)
	Для каждого СтрокаТЗ из ТаблицаПроводок Цикл
		Если СтрокаТЗ.УжеПодобран = Ложь Тогда
			СтрокаТЗ.Подобрать = Ложь;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВсеФлажки(Команда)
	Для каждого СтрокаТЗ из ТаблицаПроводок Цикл
		Если СтрокаТЗ.УжеПодобран = Ложь Тогда
			СтрокаТЗ.Подобрать = Истина;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура подбирает проводки из РБ по всем документам, кроме "Закрыти месяца" 
// по счетам доходов и расходов.
//
// Параметры:
//  ТаблицаИзХранилища  - ТаблицаЗначений - данные ТЧ "ПодобранныеПроводки" из основной формы документа.
//
&НаСервере
Процедура ПодборПроводок(ТаблицаИзХранилища = Неопределено)

	МассивТипов = Новый Массив();  
	МассивТипов.Добавить(Тип("ДокументСсылка.ЗакрытиеМесяца"));
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Хозрасчетный.Ссылка КАК Счет,
		|	Хозрасчетный.Вид КАК Вид
		|ПОМЕСТИТЬ ВременнаяТаблицаСчетов
		|ИЗ
		|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
		|ГДЕ
		|	Хозрасчетный.Временный
		|	И (Хозрасчетный.Вид = ЗНАЧЕНИЕ(ВидСчета.Активный)
		|			ИЛИ Хозрасчетный.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный))
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ХозрасчетныйРБ.Регистратор КАК ДокументПодбора,
		|	ХозрасчетныйРБ.СчетДт КАК Счет,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаСчетов.Вид = ЗНАЧЕНИЕ(ВидСчета.Активный)
		|			ТОГДА ХозрасчетныйРБ.СуммаОборот
		|		КОГДА ВременнаяТаблицаСчетов.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
		|			ТОГДА -ХозрасчетныйРБ.СуммаОборот
		|	КОНЕЦ КАК СуммаПоСчету,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаСчетов.Вид = ЗНАЧЕНИЕ(ВидСчета.Активный)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ПризнакСчета.Расходный)
		|		КОГДА ВременнаяТаблицаСчетов.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ПризнакСчета.Доходный)
		|	КОНЕЦ КАК ПризнакСчета
		|ПОМЕСТИТЬ ТаблицаПроводок
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			Авто,
		|			СчетДт В
		|				(ВЫБРАТЬ
		|					ВременнаяТаблицаСчетов.Счет
		|				ИЗ
		|					ВременнаяТаблицаСчетов КАК ВременнаяТаблицаСчетов),
		|			,
		|			,
		|			,
		|			Организация = &Организация) КАК ХозрасчетныйРБ
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаСчетов КАК ВременнаяТаблицаСчетов
		|		ПО ХозрасчетныйРБ.СчетДт = ВременнаяТаблицаСчетов.Счет
		|ГДЕ
		|	НЕ ТИПЗНАЧЕНИЯ(ХозрасчетныйРБ.Регистратор) В (&МассивТипов)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ХозрасчетныйРБ.Регистратор,
		|	ХозрасчетныйРБ.СчетКт,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаСчетов.Вид = ЗНАЧЕНИЕ(ВидСчета.Активный)
		|			ТОГДА -ХозрасчетныйРБ.СуммаОборот
		|		КОГДА ВременнаяТаблицаСчетов.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
		|			ТОГДА ХозрасчетныйРБ.СуммаОборот
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаСчетов.Вид = ЗНАЧЕНИЕ(ВидСчета.Активный)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ПризнакСчета.Расходный)
		|		КОГДА ВременнаяТаблицаСчетов.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ПризнакСчета.Доходный)
		|	КОНЕЦ
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			Авто,
		|			,
		|			,
		|			СчетКт В
		|				(ВЫБРАТЬ
		|					ВременнаяТаблицаСчетов.Счет
		|				ИЗ
		|					ВременнаяТаблицаСчетов КАК ВременнаяТаблицаСчетов),
		|			,
		|			Организация = &Организация) КАК ХозрасчетныйРБ
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаСчетов КАК ВременнаяТаблицаСчетов
		|		ПО ХозрасчетныйРБ.СчетКт = ВременнаяТаблицаСчетов.Счет
		|ГДЕ
		|	НЕ ТИПЗНАЧЕНИЯ(ХозрасчетныйРБ.Регистратор) В (&МассивТипов)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаПроводок.ДокументПодбора КАК ДокументПодбора,
		|	ТаблицаПроводок.Счет КАК Счет,
		|	СУММА(ТаблицаПроводок.СуммаПоСчету) КАК СуммаПоСчету,
		|	ТаблицаПроводок.ПризнакСчета КАК ПризнакСчета
		|ИЗ
		|	ТаблицаПроводок КАК ТаблицаПроводок
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаПроводок.Счет,
		|	ТаблицаПроводок.ДокументПодбора,
		|	ТаблицаПроводок.ПризнакСчета";
	Запрос.УстановитьПараметр("НачалоПериода", 	НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", 	КонецПериода);
	Запрос.УстановитьПараметр("Организация", 	Организация);
	Запрос.УстановитьПараметр("МассивТипов", 	МассивТипов);
	
	Если ТаблицаИзХранилища = Неопределено Тогда
		ТаблицаПроводок.Загрузить(Запрос.Выполнить().Выгрузить());	
	Иначе
		ТЗ = Запрос.Выполнить().Выгрузить();
		                                                   
		ТЗ.Колонки.Добавить("Подобрать");
		ТЗ.Колонки.Добавить("УжеПодобран");
		ТЗ.ЗаполнитьЗначения(Ложь, "Подобрать, УжеПодобран");
		
		Для Каждого СтрокаТаблицыЗначений Из ТЗ Цикл
			
			СтруктураОтбора = Новый Структура();
			СтруктураОтбора.Вставить("ДокументПодбора", СтрокаТаблицыЗначений.ДокументПодбора);
			СтруктураОтбора.Вставить("Счет", 			СтрокаТаблицыЗначений.Счет);
			СтруктураОтбора.Вставить("СуммаПоСчету", 	СтрокаТаблицыЗначений.СуммаПоСчету);
			
			МассивСтрок = ТаблицаИзХранилища.НайтиСтроки(СтруктураОтбора);
			
			Если МассивСтрок.Количество() > 0 Тогда
				СтрокаТаблицыЗначений.Подобрать = Истина;
				СтрокаТаблицыЗначений.УжеПодобран = Истина;
			КонецЕсли;
			
			НоваяСтрока = ТаблицаПроводок.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицыЗначений);
		КонецЦикла;
	КонецЕсли;	

	ТаблицаПроводок.Сортировать("ДокументПодбора");
КонецПроцедуры

// Функция помещает результаты подбора в хранилище
//
&НаСервере
Функция ЗаписатьПодборВХранилище() 
	
	ПараметрыОтбора = Новый Структура();
	ПараметрыОтбора.Вставить("Подобрать", Истина);
	ПараметрыОтбора.Вставить("УжеПодобран", Ложь);
	ДанныеТаблицыЗначений = ТаблицаПроводок.НайтиСтроки(ПараметрыОтбора);
	
	Возврат ПоместитьВоВременноеХранилище(ДанныеТаблицыЗначений, УникальныйИдентификаторФормыВладельца);
	
КонецФункции //ЗаписатьПодборВХранилище()

#КонецОбласти