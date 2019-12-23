﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установка реквизитов формы.
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = КонецМесяца(ТекущаяДатаСеанса());
	КонецЕсли;
	
	ДанныеУчетнойПолитикиПоПерсоналу = БухгалтерскийУчетСервер.ПолучитьДанныеУчетнойПолитикиПоПерсоналу(ДатаДокумента, Объект.Организация);
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
	// РаботаСФормами
	РаботаСФормамиСервер.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец РаботаСФормами
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
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
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом 
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
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

	// Обработка события изменения даты.
	ДатаПередИзменением = ДатаДокумента;
	ДатаДокумента = Объект.Дата;
	Если Объект.Дата <> ДатаПередИзменением Тогда
		
		Объект.Дата = КонецМесяца(Объект.Дата);
		
		СтруктураДанные = ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением);
		Если СтруктураДанные.РазностьДат <> 0 Тогда
			Объект.Номер = "";
		КонецЕсли;		
		
	КонецЕсли;
	
	БухгалтерскийУчетВызовСервераПовтИсп.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Организация.
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	// Обработка события изменения организации.
	Объект.Номер = "";
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьЗакрытиеМесяца(Команда)
	
	Если Объект.НалогиПоЗарплате.Количество() > 0
		Или Объект.Удержания.Количество() > 0 Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросВыполнитьЗакрытиеМесяца", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Табличные части документа будут перезаполнены. Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		ВыполнитьЗакрытиеМесяцаНаКлиенте();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НалогиПоЗарплатеПодробно(Команда)
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"НалогиПоЗарплатеПодробно",
		"Пометка",
		Не Элементы.НалогиПоЗарплатеПодробно.Пометка);

	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Процедура ОтветНаВопросВыполнитьЗакрытиеМесяца(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Объект.НалогиПоЗарплате.Очистить();
		Объект.Удержания.Очистить();
		Объект.НалогиСОрганизации.Очистить();
		Объект.НалогиСОрганизацииКорректировки.Очистить();
		
		ВыполнитьЗакрытиеМесяцаНаКлиенте();
	КонецЕсли; 
КонецПроцедуры	

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

// Процедура устанавливает видимость и доступность элементов.
//
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	Элементы.НалогиПоЗарплатеСуммаУдержано.Видимость = Элементы.НалогиПоЗарплатеПодробно.Пометка;
	Элементы.НалогиПоЗарплатеСуммаДопДоход.Видимость = Элементы.НалогиПоЗарплатеПодробно.Пометка;
	Элементы.НалогиПоЗарплатеОДСФ.Видимость = Элементы.НалогиПоЗарплатеПодробно.Пометка;
	Элементы.НалогиПоЗарплатеОДПН.Видимость = Элементы.НалогиПоЗарплатеПодробно.Пометка;
	Элементы.НалогиПоЗарплатеДоплатаПН.Видимость = Элементы.НалогиПоЗарплатеПодробно.Пометка;
	Элементы.НалогиПоЗарплатеМРД.Видимость = Элементы.НалогиПоЗарплатеПодробно.Пометка;
	Элементы.НалогиПоЗарплатеОДПрофВзнос.Видимость = Элементы.НалогиПоЗарплатеПодробно.Пометка;
	Элементы.НалогиПоЗарплатеОтработаноДней.Видимость = Элементы.НалогиПоЗарплатеПодробно.Пометка;
	Элементы.НалогиПоЗарплатеПФФ.Видимость = Элементы.НалогиПоЗарплатеПодробно.Пометка;
	Элементы.НалогиПоЗарплатеМСФ.Видимость = Элементы.НалогиПоЗарплатеПодробно.Пометка;
	Элементы.НалогиПоЗарплатеФОТФ.Видимость = Элементы.НалогиПоЗарплатеПодробно.Пометка;
	Элементы.НалогиПоЗарплатеМСР.Видимость = Элементы.НалогиПоЗарплатеПодробно.Пометка;
	Элементы.НалогиПоЗарплатеФОТР.Видимость = Элементы.НалогиПоЗарплатеПодробно.Пометка;
	Элементы.НалогиПоЗарплатеСтатус.Видимость = Элементы.НалогиПоЗарплатеПодробно.Пометка;
	Элементы.НалогиПоЗарплатеПрименятьВычет.Видимость = Элементы.НалогиПоЗарплатеПодробно.Пометка;
	
	Элементы.НалогиПоЗарплатеПФФКорректировка.Видимость = Элементы.НалогиПоЗарплатеПодробно.Пометка;
	Элементы.НалогиПоЗарплатеМСФКорректировка.Видимость = Элементы.НалогиПоЗарплатеПодробно.Пометка;
	Элементы.НалогиПоЗарплатеФОТФКорректировка.Видимость = Элементы.НалогиПоЗарплатеПодробно.Пометка;
	Элементы.НалогиПоЗарплатеСреднемесячнаяЗПСФПриведенная.Видимость = Элементы.НалогиПоЗарплатеПодробно.Пометка;

	Элементы.НалогиПоЗарплатеПрофВзнос.Видимость = ДанныеУчетнойПолитикиПоПерсоналу.СтавкаПрофВзнос <> 0;
	Элементы.НалогиПоЗарплатеОДПрофВзнос.Видимость = Элементы.НалогиПоЗарплатеПодробно.Пометка И ДанныеУчетнойПолитикиПоПерсоналу.СтавкаПрофВзнос <> 0;
	
	Элементы.СтраницаНалогиСОрганизации.Видимость = Элементы.НалогиПоЗарплатеПодробно.Пометка;
	Элементы.СтраницаНалогиСОрганизацииКорректировки.Видимость = Элементы.НалогиПоЗарплатеПодробно.Пометка;
	Элементы.ГруппаИтогиДоп.Видимость = Элементы.НалогиПоЗарплатеПодробно.Пометка;
	
	Если Элементы.НалогиПоЗарплатеПодробно.Пометка Тогда 
		Элементы.НалогиПоЗарплатеГруппаСФ.Группировка = ГруппировкаКолонок.Вертикальная;
	Иначе 
		Элементы.НалогиПоЗарплатеГруппаСФ.Группировка = ГруппировкаКолонок.Горизонтальная;
	КонецЕсли;	
КонецПроцедуры 

// Функция возвращает результат возможности записи/отмены проведения документа перед рассчетом
//
// Параметры:
//  Действие - действие, при котором выполняется проверка
// Возвращаемое значение:
//   Булево - 
//
&НаКлиенте
Функция ЗаписатьДокументОтменивПроведение()
	Если Объект.Проведен Тогда
		ЗаписатьНаСервере(РежимЗаписиДокумента.ОтменаПроведения);		
	ИначеЕсли НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		Объект.Дата = ДатаДокумента;
		ЗаписатьНаСервере(РежимЗаписиДокумента.Запись);		
	КонецЕсли;	
	
	Модифицированность = Ложь;

	Возврат НЕ Объект.Проведен И ЗначениеЗаполнено(Объект.Ссылка);
КонецФункции // ЗаписатьДокументОтменивПроведение()

// Процедура - Записать на сервере
//
// Параметры:
//  Режим	 - РежимЗаписи	 - 
//
&НаСервере
Процедура ЗаписатьНаСервере(Режим)
	Документ = РеквизитФормыВЗначение("Объект");
	Попытка
		Документ.Записать(Режим);
	Исключение
		ТекстСообщения = НСтр("ru = 'Не удалось завершить %1 документа.
			|Техническая информация об ошибке: %2'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, Строка(Режим), КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));	
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось завершить проведение %1 по причине: %2'"), Строка(Режим), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка закрытия месяца'", ОбщегоНазначения.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
	КонецПопытки;	
	ЗначениеВРеквизитФормы(Документ, "Объект");
КонецПроцедуры // ЗаписатьНаСервере()

// Процедура - Выполнить закрытие месяца на клиенте
//
&НаКлиенте
Процедура ВыполнитьЗакрытиеМесяцаНаКлиенте()

	Если НЕ ЗаписатьДокументОтменивПроведение() Тогда 
		Возврат;
	КонецЕсли;	
	
	Если НЕ ПроверитьЗаполнение() Тогда 
		Возврат;
	КонецЕсли;
	
	ЕстьОшибки = Ложь;

	ВыполнитьЗакрытиеМесяцаНаСервере(ЕстьОшибки);
	
	ТекстОповещения = НСтр("ru = 'Выполнен расчет налогов и удержаний'");
	ТекстПояснения = ?(ЕстьОшибки, 
		НСтр("ru = 'При расчете возникли ошибки'"), 
		НСтр("ru = 'При расчете ошибок не обнаружено'"));
	ПоказатьОповещениеПользователя(ТекстОповещения, , ТекстПояснения, БиблиотекаКартинок.Информация32);
	
	Если Не ЕстьОшибки Тогда
		ПараметрыЗаписи = Новый Структура;
		ПараметрыЗаписи.Вставить("РежимЗаписи", РежимЗаписиДокумента.Проведение);
		Записать(ПараметрыЗаписи);
	КонецЕсли;

КонецПроцедуры // ВыполнитьЗакрытиеМесяцаНаКлиенте()

// Процедура - Заполнить табличную часть на сервере
//
&НаСервере
Процедура ВыполнитьЗакрытиеМесяцаНаСервере(ЕстьОшибки)
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ВыполнитьЗакрытиеМесяца(ЕстьОшибки);
	ЗначениеВРеквизитФормы(Документ, "Объект");
КонецПроцедуры // ВыполнитьЗакрытиеМесяцаНаСервере()

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти