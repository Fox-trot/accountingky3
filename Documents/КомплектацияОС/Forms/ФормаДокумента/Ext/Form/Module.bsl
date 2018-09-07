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
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДатаСеанса();
	КонецЕсли;
	
	ДанныеУчетнойПолитики = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьДанныеУчетнойПолитикиОрганизаций(ДатаДокумента, Объект.Организация);
	
	//СоздатьПараметрыУчетаОС();	
	
	//Если ЗначениеЗаполнено(Объект.ОсновноеСредство) Тогда
	//	ЗаполнитьПараметрыУчетаОС();
	//КонецЕсли;
	
	//РодительскоеОСУжеПринятоКУчету = РодительскоеОСУжеПринятоКУчету(ДатаДокумента, Объект.ОсновноеСредство);

	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменений
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменений
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры // ПриЧтенииНаСервере()

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПодборОСПроизведен" 
		И ЗначениеЗаполнено(Параметр) 
		// Проверка на владельца формы
		И Источник <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000")
		И Источник = УникальныйИдентификатор Тогда
		
		АдресЗапасовВХранилище = Параметр;
		ПолучитьОСИзХранилища(АдресЗапасовВХранилище, "ОС");
	КонецЕсли;
КонецПроцедуры

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
	// Обработка события изменения даты.
	ДатаПередИзменением = ДатаДокумента;
	ДатаДокумента = Объект.Дата;
	Если Объект.Дата <> ДатаПередИзменением Тогда
		СтруктураДанные = ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением);
		Если СтруктураДанные.РазностьДат <> 0 Тогда
			Объект.Номер = "";
		КонецЕсли;
	КонецЕсли;
	
	БухгалтерскийУчетВызовСервераПовтИсп.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
	ДанныеУчетнойПолитики = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьДанныеУчетнойПолитикиОрганизаций(ДатаДокумента, Объект.Организация);
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Организация.
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	// Обработка события изменения организации.
	Объект.Номер = "";
	БухгалтерскийУчетВызовСервераПовтИсп.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
	ДанныеУчетнойПолитики = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьДанныеУчетнойПолитикиОрганизаций(ДатаДокумента, Объект.Организация);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Комментарий.
//
&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	ПодключитьОбработчикОжидания("УстановитьПиктограммуКомментария", 0.1, Истина);
КонецПроцедуры

// Процедура - обработчик события НачалоВыбора поля ввода Комментарий.
//
&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ОсновноеСредство.
//
&НаКлиенте
Процедура ОсновноеСредствоПриИзменении(Элемент)
	Если НЕ ЗначениеЗаполнено(Объект.ОсновноеСредство) Тогда
		Возврат;
	КонецЕсли;	
	
	Если НЕ ЭтоКомплект(Объект.ОсновноеСредство) Тогда
		ТекстСообщения = НСтр("ru = 'Выбранное Основное средство - не является комплектом!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.ОсновноеСредство",,Истина);
		
		Объект.ОсновноеСредство = ПредопределенноеЗначение("Справочник.ОсновныеСредства.ПустаяСсылка");
		УстановитьВидимостьДоступностьЭлементов();
		Возврат;
	КонецЕсли;
	
	РодительскоеОСУжеПринятоКУчету = РодительскоеОСУжеПринятоКУчету(ДатаДокумента, Объект.ОсновноеСредство);
	Если РодительскоеОСУжеПринятоКУчету Тогда
		ТекстСообщения = НСтр("ru = 'Выбранное Основное средство уже принято к учету! Выберите другое ОС.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.ОсновноеСредство",,Истина);
		
		Объект.ОсновноеСредство = ПредопределенноеЗначение("Справочник.ОсновныеСредства.ПустаяСсылка");
		УстановитьВидимостьДоступностьЭлементов();
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Объект, ПараметрыОсновногоСредства(ДатаДокумента, Объект.ОсновноеСредство));
	
	ЭлементыКомплекта = СоставКомплектаОС(Объект.ОсновноеСредство);
	
	КоличествоСтрокТЧПредыдущее = Объект.ОС.Количество();
	Объект.ОС.Очистить();
	Если ЭлементыКомплекта.Количество() > 0 Тогда
		Для каждого ОсновноеСредствоВСоставе Из ЭлементыКомплекта Цикл
			СтрокаТабличнойЧасти = Объект.ОС.Добавить();	
			СтрокаТабличнойЧасти.ОсновноеСредство = ОсновноеСредствоВСоставе;		
		КонецЦикла;
		
		Если КоличествоСтрокТЧПредыдущее = 0 Тогда
			ТекстСообщения = НСтр("ru = 'Выбранный комплект содержит в своем составе основные средства.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);		
		Иначе
			ТекстСообщения = НСтр("ru = 'Выбранный комплект содержит в своем составе основные средства. Табличная часть перезаполнена.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);		
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОС

&НаКлиенте
Процедура ОСПередУдалением(Элемент, Отказ)
	СтрокаТабличнойЧасти = Элементы.ОС.ТекущиеДанные;
	Если НЕ СтрокаТабличнойЧасти.Изменение Тогда
	 	Отказ = Истина;
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Вы не можете удалить Основное средство ""%1"" из табличной части, т.к. оно уже входит в комплект.'"), 
			СтрокаТабличнойЧасти.ОсновноеСредство);		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.ОС[" + (СтрокаТабличнойЧасти.НомерСтроки - 1) + "].ОсновноеСредство",,Ложь);
			
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подбор(Команда)
	УправлениеВнеоборотнымиАктивамиКлиент.ОткрытьПодборКомплектацияОС(ЭтаФорма, "ОС");

КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСуммы(Команда)
	
	Отказ = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Объект.ОсновноеСредство) Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнено Основное средство! Расчет документа отменено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.ОсновноеСредство",,Отказ)		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.СчетУчетаМодернизации) Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнен Счет учета модернизации! Расчет документа отменено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.СчетУчетаМодернизации",,Отказ)		
	КонецЕсли;
	
	Если Отказ Тогда 
		Возврат
	КонецЕсли;	
	
	Если Объект.ПараметрыОС.Количество() > 0 Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросРассчитатьСтоимостьМодернизации", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Стоимость модернизации будет перерасчитана! Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		//РасчетАмортизацииИОстаточнойСтоимости();
		//РасчитатьСтоимостьМодернизации();
	КонецЕсли;
КонецПроцедуры      

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Процедура ОтветНаВопросРассчитатьСтоимостьМодернизации(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		//РасчетАмортизацииИОстаточнойСтоимости();
		//РасчитатьСтоимостьМодернизации();
	КонецЕсли; 
КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость и доступность элементов.
//
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	Элементы.ОСПодбор.Видимость = Истина;
	Элементы.ОСИзменение.Видимость = Истина;
	
	Если Объект.ВидОперации = Перечисления.ВидыОперацийКомплектацияОС.Комплектация Тогда
		Элементы.ОСИзменение.Видимость = Ложь;	

	ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийКомплектацияОС.Добавление Тогда
		Элементы.ОСИзменение.Заголовок = "Добавлено";
		
	ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийКомплектацияОС.ВыводИзКомплекта Тогда
		Элементы.ОСИзменение.Заголовок = "Удалено";
		Элементы.ОСПодбор.Видимость = Ложь;
		
	ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийКомплектацияОС.Ликвидация Тогда
		Элементы.ОСИзменение.Видимость = Ложь;
		Элементы.ОСПодбор.Видимость = Ложь;
	
	КонецЕсли;

КонецПроцедуры

// Получает набор данных с сервера для процедуры ДатаПриИзменении.
//
&НаСервере
Функция ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением)
	РазностьДат = БухгалтерскийУчетСервер.ПроверитьНомерДокумента(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("РазностьДат",	РазностьДат);
	
	Возврат СтруктураДанные;
КонецФункции // ПолучитьДанныеДатаПриИзменении()

// Процедура - Установить пиктограмму комментария.
//
&НаКлиенте
Процедура УстановитьПиктограммуКомментария()
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
КонецПроцедуры

// Процедура получает список ОС из временного хранилища
//
&НаСервере
Процедура ПолучитьОСИзХранилища(АдресЗапасовВХранилище, ИмяТабличнойЧасти)
	ТаблицаДляЗагрузки = ПолучитьИзВременногоХранилища(АдресЗапасовВХранилище);
	
	МассивОсновныхСредств = Новый Массив;
	
	// МассивОсновныхСредствИсключения - массив ОС, которые входят в другие комплекты
	МассивОсновныхСредствИсключения = Новый Массив;
	МассивОсновныхСредствИсключения = ПолучитьОсновныеСредстваВходящиеВДругиеКомплекты(Объект.ОсновноеСредство, ТаблицаДляЗагрузки.ВыгрузитьКолонку("ОсновноеСредство"));
	
	Для Каждого СтрокаЗагрузки Из ТаблицаДляЗагрузки Цикл
		НайденныеСтроки = Объект.ОС.НайтиСтроки(Новый Структура("ОсновноеСредство", СтрокаЗагрузки.ОсновноеСредство));
		
		Если НайденныеСтроки.Количество() > 0 Тогда 
			Продолжить;
		КонецЕсли;
		
		НомерИндексаИсключенияОС = МассивОсновныхСредствИсключения.Найти(СтрокаЗагрузки.ОсновноеСредство);
		Если НомерИндексаИсключенияОС <> Неопределено Тогда 
			Продолжить;
		КонецЕсли;		
		
		СтрокаТабличнойЧасти = Объект.ОС.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаЗагрузки);
		СтрокаТабличнойЧасти.Изменение = Истина;
		МассивОсновныхСредств.Добавить(СтрокаТабличнойЧасти.ОсновноеСредство);
	КонецЦикла;
	
	ДополнитьСтрокиНаСервере(МассивОсновныхСредств);
КонецПроцедуры // ПолучитьЗапасыИзХранилища()

// Процедура заполняет строки
//
// Параметры:
//  МассивОсновныхСредств  - Массив - массив ОС, по которым нужно заполнить строки, если не указано- заполняются все строки
//
&НаСервере
Процедура ДополнитьСтрокиНаСервере(МассивОсновныхСредств = Неопределено)
	Если МассивОсновныхСредств = Неопределено Тогда 
		МассивОсновныхСредств = Объект.ОС.Выгрузить().ВыгрузитьКолонку("ОсновноеСредство");
	КонецЕсли;		
	
	Если МассивОсновныхСредств.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;	
	
	УправлениеВнеоборотнымиАктивами.ЗаполнитьДанныеОсновныхСредствВТабличнойЧасти(Объект.Ссылка, ДатаДокумента, Объект.Организация, Объект.ОС, МассивОсновныхСредств);
КонецПроцедуры // ДополнитьСтрокиНаСервере()

// Проверка на вхождение в другие комплекты ОС
//
// Параметры:
//  Комплект  - ОсновноеСредство - Основное средство, для которого собирается комплект ОС
//  МассивОсновныхСредств  - массив - массив ОС, которые проверяются на вхождение в другие комплекты
//
&НаСервере
Функция ПолучитьОсновныеСредстваВходящиеВДругиеКомплекты(Комплект, МассивОсновныхСредств)
	МассивИсключенияОС = Новый Массив;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СоставОССрезПоследних.ОсновноеСредство КАК ОсновноеСредство
		|ИЗ
		|	РегистрСведений.СоставОС.СрезПоследних(&Дата, НЕ ОсновноеСредство = &Комплект) КАК СоставОССрезПоследних
		|ГДЕ
		|	СоставОССрезПоследних.ОсновноеСредствоВСоставеКомплекта В (&МассивОсновныхСредств)
		|	И СоставОССрезПоследних.СостояниеВСоставеОС В (ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКомплектацияОС.Комплектация), ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКомплектацияОС.Добавление))";
	
	Запрос.УстановитьПараметр("Дата", 		Объект.Дата);
	Запрос.УстановитьПараметр("Комплект", 	Комплект);
	Запрос.УстановитьПараметр("МассивОсновныхСредств", МассивОсновныхСредств);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		МассивИсключенияОС.Добавить(ВыборкаДетальныеЗаписи.ОсновноеСредство);
	КонецЦикла;
	
	Возврат МассивИсключенияОС;	
	
КонецФункции //

// Получение состава комплекта ОС
//
// Параметры:
//  Комплект  - ОсновноеСредство - Основное средство, для которого собирается комплект ОС
//
&НаСервере
Функция СоставКомплектаОС(Комплект)
	СоставОС = Новый Массив;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СоставОССрезПоследних.ОсновноеСредствоВСоставеКомплекта КАК ОсновноеСредство
		|ИЗ
		|	РегистрСведений.СоставОС.СрезПоследних(
		|			&Дата,
		|			ОсновноеСредство = &Комплект
		|				И НЕ Регистратор = &Ссылка) КАК СоставОССрезПоследних
		|ГДЕ
		|	СоставОССрезПоследних.СостояниеВСоставеОС В (ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКомплектацияОС.Комплектация), ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКомплектацияОС.Добавление))";
	
	Запрос.УстановитьПараметр("Дата", 		Объект.Дата);
	Запрос.УстановитьПараметр("Ссылка", 	Объект.Ссылка);	
	Запрос.УстановитьПараметр("Комплект", 	Комплект);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СоставОС.Добавить(ВыборкаДетальныеЗаписи.ОсновноеСредство);
	КонецЦикла;
	
	Возврат СоставОС;	
	
КонецФункции //

&НаСервереБезКонтекста
Функция ЭтоКомплект(ОсновноеСредство)
	
	Возврат ОсновноеСредство.Комплект;

КонецФункции // ЭтоКомплект(ОсновноеСредство)

&НаСервереБезКонтекста
Функция РодительскоеОСУжеПринятоКУчету(Дата, ОсновноеСредство)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СостоянияОССрезПоследних.ОсновноеСредство КАК ОсновноеСредство,
		|	СостоянияОССрезПоследних.Состояние КАК Состояние
		|ИЗ
		|	РегистрСведений.СостоянияОС.СрезПоследних(&Дата, ОсновноеСредство = &ОсновноеСредство) КАК СостоянияОССрезПоследних
		|ГДЕ
		|	СостоянияОССрезПоследних.Состояние = ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийОС.ПринятоКУчету)";
	
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("ОсновноеСредство", ОсновноеСредство);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда	
		Возврат Истина;		
	Иначе	
		Возврат Ложь;	
	КонецЕсли;
	
КонецФункции // РодительскоеОСУжеПринятоКУчету()

&НаСервереБезКонтекста
Функция ПараметрыОсновногоСредства(Дата, ОсновноеСредство)
	ДанныеОС = Новый Структура("ОсновноеСредство, СчетУчета, Подразделение, МОЛ",
				ОсновноеСредство, Неопределено, Неопределено, Неопределено);		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	&ОсновноеСредство КАК ОсновноеСредство
		|ПОМЕСТИТЬ ВременнаяТаблицаНачальная
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаНачальная.ОсновноеСредство КАК ОсновноеСредство,
		|	ПараметрыУчетаОССрезПоследних.СчетУчета КАК СчетУчета,
		|	МестонахождениеОССрезПоследних.Подразделение КАК Подразделение,
		|	МестонахождениеОССрезПоследних.МОЛ КАК МОЛ
		|ИЗ
		|	ВременнаяТаблицаНачальная КАК ВременнаяТаблицаНачальная
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыУчетаОС.СрезПоследних(&Дата, ОсновноеСредство = &ОсновноеСредство) КАК ПараметрыУчетаОССрезПоследних
		|		ПО ВременнаяТаблицаНачальная.ОсновноеСредство = ПараметрыУчетаОССрезПоследних.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОС.СрезПоследних(&Дата, ОсновноеСредство = &ОсновноеСредство) КАК МестонахождениеОССрезПоследних
		|		ПО ВременнаяТаблицаНачальная.ОсновноеСредство = МестонахождениеОССрезПоследних.ОсновноеСредство";
	
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("ОсновноеСредство", ОсновноеСредство);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	ВыборкаДетальныеЗаписи.Следующий();
	ЗаполнитьЗначенияСвойств(ДанныеОС, ВыборкаДетальныеЗаписи);
	
	Возврат ДанныеОС;
	
КонецФункции // ()


#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры




// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

