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
	
	// Установка реквизитов формы.
	ДатаДокумента = Объект.Дата;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменений
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменений
	
КонецПроцедуры // ПриЧтенииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода Дата.
// В процедуре определяется ситуация, когда при изменении своей даты документ 
// оказывается в другом периоде нумерации документов, и в этом случае
// присваивает документу новый уникальный номер.
// Переопределяет соответствующий параметр формы.
//
&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	Объект.Дата = КонецМесяца(Объект.Дата);
	Если ЕстьДокументВУказанныйПериод(Объект.Дата) Тогда
		ТекстСообщения = НСтр("ru = 'Для указанного периода уже существует документ Отчет по косвенным налогам!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"Дата",,Истина);				
		Объект.Дата	= ДатаДокумента;
	    Возврат;
	КонецЕсли;	
	
	// Обработка события изменения даты.
	ДатаПередИзменением = ДатаДокумента;
	ДатаДокумента = Объект.Дата;
	Если Объект.Дата <> ДатаПередИзменением Тогда
		СтруктураДанные = ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением);
		Если СтруктураДанные.РазностьДат <> 0 Тогда
			Объект.Номер = "";
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Организация.
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	// Обработка события изменения организации.
	Объект.Номер = "";
	БухгалтерскийУчетВызовСервера.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)	
	Если Объект.ОсновнаяФорма.Количество() > 0 Тогда 
		ДополнительныеПараметры = Новый Структура();
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьТабличыеЧасти", ЭтотОбъект, ДополнительныеПараметры);
		ТекстВопроса = НСтр("ru = 'Табличные части документа будут очищены! Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);	
	Иначе
		ЗаполнитьТабличныеЧастиНаСервере();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьТабличыеЧасти(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Объект.ОсновнаяФорма.Очистить();
		Объект.Приложение1.Очистить();
        ЗаполнитьТабличныеЧастиНаСервере();
    КонецЕсли;
КонецПроцедуры // ЗаполнитьПоОснованию()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получает набор данных с сервера для процедуры ДатаПриИзменении.
//
&НаСервере
Функция ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением)
	РазностьДат = БухгалтерскийУчетСервер.ПроверитьНомерДокумента(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("РазностьДат",	РазностьДат);
	
	Возврат СтруктураДанные;
КонецФункции // ПолучитьДанныеДатаПриИзменении()

&НаСервере
Функция ЕстьДокументВУказанныйПериод(Дата)

	Запрос = Новый Запрос;
	Запрос.Текст = 	
	"ВЫБРАТЬ
	|	ОтчетПоКосвеннымНалогам.Ссылка
	|ИЗ
	|	Документ.ОтчетПоКосвеннымНалогам КАК ОтчетПоКосвеннымНалогам
	|ГДЕ
	|	НЕ ОтчетПоКосвеннымНалогам.ПометкаУдаления
	|	И КОНЕЦПЕРИОДА(ОтчетПоКосвеннымНалогам.Дата, МЕСЯЦ) = &Дата";

	Запрос.УстановитьПараметр("Дата", Дата);		
	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат Выборка.Количество() > 0 	

КонецФункции // КонтрольСозданияНовогоДокумента(Отказ, Объект)

&НаСервере
Процедура ЗаполнитьТабличныеЧастиНаСервере()
	
	ЗаполнитьПриложение1();
	ЗаполнитьОсновнаяФорма()	
	
КонецПроцедуры // ЗаполнитьТабличныеЧастиНаСервере(ИмяКоманды)

&НаСервере
Процедура ЗаполнитьПриложение1()
	
	СТЧ 				 = Объект.Приложение1.Добавить();
	СТЧ.НомерГрафыОтчета = "150";
	СТЧ.Содержание		 = "Облагаемый импорт предметов лизинга";
	
	СТЧ 				 = Объект.Приложение1.Добавить();
	СТЧ.НомерГрафыОтчета = "151";
	СТЧ.Содержание		 = "Облагаемый импорт товаров, являющихся продуктами переработки давальческого сырья";
	
	СТЧ 				 = Объект.Приложение1.Добавить();
	СТЧ.НомерГрафыОтчета = "152";
	СТЧ.Содержание		 = "Импорт транспортных средств";
	
	СТЧ 				 = Объект.Приложение1.Добавить();
	СТЧ.НомерГрафыОтчета = "153";
	СТЧ.Содержание		 = "Прочий облагаемый импорт товаров , не указанных в строках 150, 151 и 152";
	
	СТЧ 				 = Объект.Приложение1.Добавить();
	СТЧ.НомерГрафыОтчета = "154";
	СТЧ.Содержание		 = "Итого облагаемый импорт (=150+151+152+153)";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НДСНаИмпортОбороты.ПоказательИмпорта,
	|	НДСНаИмпортОбороты.СуммаОборот + НДСНаИмпортОбороты.СуммаАкцизОборот КАК Сумма,
	|	НДСНаИмпортОбороты.СуммаНДСОборот КАК СуммаНДС
	|ПОМЕСТИТЬ ВременнаяТаблицаИмпорт
	|ИЗ
	|	РегистрНакопления.НДСНаИмпорт.Обороты(&НачалоПериода, &КонецПериода, Авто, Организация = &Организация) КАК НДСНаИмпортОбороты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	""150"" КАК НомерГрафы,
	|	СУММА(ВременнаяТаблицаИмпорт.Сумма) КАК Сумма,
	|	СУММА(ВременнаяТаблицаИмпорт.СуммаНДС) КАК СуммаНДС
	|ПОМЕСТИТЬ ВременнаяТаблицаСуммы
	|ИЗ
	|	ВременнаяТаблицаИмпорт КАК ВременнаяТаблицаИмпорт
	|ГДЕ
	|	ВременнаяТаблицаИмпорт.ПоказательИмпорта = ЗНАЧЕНИЕ(Справочник.ПоказателиИмпорта.ПредметыЛизинга)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""151"",
	|	СУММА(ВременнаяТаблицаИмпорт.Сумма),
	|	СУММА(ВременнаяТаблицаИмпорт.СуммаНДС)
	|ИЗ
	|	ВременнаяТаблицаИмпорт КАК ВременнаяТаблицаИмпорт
	|ГДЕ
	|	ВременнаяТаблицаИмпорт.ПоказательИмпорта = ЗНАЧЕНИЕ(Справочник.ПоказателиИмпорта.ПродуктыПереработкиДС)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""152"",
	|	СУММА(ВременнаяТаблицаИмпорт.Сумма),
	|	СУММА(ВременнаяТаблицаИмпорт.СуммаНДС)
	|ИЗ
	|	ВременнаяТаблицаИмпорт КАК ВременнаяТаблицаИмпорт
	|ГДЕ
	|	ВременнаяТаблицаИмпорт.ПоказательИмпорта = ЗНАЧЕНИЕ(Справочник.ПоказателиИмпорта.ТранспортныеСредства)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""153"",
	|	СУММА(ВременнаяТаблицаИмпорт.Сумма),
	|	СУММА(ВременнаяТаблицаИмпорт.СуммаНДС)
	|ИЗ
	|	ВременнаяТаблицаИмпорт КАК ВременнаяТаблицаИмпорт
	|ГДЕ
	|	ВременнаяТаблицаИмпорт.ПоказательИмпорта = ЗНАЧЕНИЕ(Справочник.ПоказателиИмпорта.Прочее)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""154"",
	|	СУММА(ВременнаяТаблицаИмпорт.Сумма),
	|	СУММА(ВременнаяТаблицаИмпорт.СуммаНДС)
	|ИЗ
	|	ВременнаяТаблицаИмпорт КАК ВременнаяТаблицаИмпорт
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Приложение1.НомерГрафыОтчета,
	|	Приложение1.Содержание
	|ПОМЕСТИТЬ ТаблЧастьПриложение1
	|ИЗ
	|	&Приложение1 КАК Приложение1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблЧастьПриложение1.НомерГрафыОтчета,
	|	ТаблЧастьПриложение1.Содержание,
	|	ВременнаяТаблицаСуммы.Сумма,
	|	ВременнаяТаблицаСуммы.СуммаНДС
	|ИЗ
	|	ТаблЧастьПриложение1 КАК ТаблЧастьПриложение1
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаСуммы КАК ВременнаяТаблицаСуммы
	|		ПО ТаблЧастьПриложение1.НомерГрафыОтчета = ВременнаяТаблицаСуммы.НомерГрафы";
	
	Запрос.УстановитьПараметр("НачалоПериода", 	НачалоМесяца(ДатаДокумента));
	Запрос.УстановитьПараметр("КонецПериода", 	КонецМесяца(ДатаДокумента));
	Запрос.УстановитьПараметр("Организация", 	Объект.Организация);
	
	Запрос.УстановитьПараметр("Приложение1", 	Объект.Приложение1.Выгрузить());
	
	Объект.Приложение1.Загрузить(Запрос.Выполнить().Выгрузить());
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОсновнаяФорма()
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("НомерГрафыОтчета", "154");	
	МассивСтрок = Объект.Приложение1.НайтиСтроки(ПараметрыОтбора);
	
	СтрокаТабличнойЧасти = Объект.ОсновнаяФорма.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета 	= "050";                       	
	СтрокаТабличнойЧасти.Содержание		 	= "Стоимость облагаемого импорта";
	СтрокаТабличнойЧасти.Сумма = ?(МассивСтрок.Количество() > 0, МассивСтрок[0].Сумма, 0);

	СтрокаТабличнойЧасти = Объект.ОсновнаяФорма.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета 	= "051";
	СтрокаТабличнойЧасти.Содержание		 	= "Сумма НДС на импорт";
	СтрокаТабличнойЧасти.Сумма = ?(МассивСтрок.Количество() > 0, МассивСтрок[0].СуммаНДС, 0);
			
КонецПроцедуры

#КонецОбласти

