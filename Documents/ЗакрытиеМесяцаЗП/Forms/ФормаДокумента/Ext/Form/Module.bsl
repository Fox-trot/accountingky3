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
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрокой");
		
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
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрокой");

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
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
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
	Если НЕ ЗаписатьДокументОтменивПроведение() Тогда 
		Возврат;
	КонецЕсли;	
	
	Если Объект.НалогиПоЗарплате.Количество() > 0
		Или Объект.Удержания.Количество() > 0 Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросВыполнитьЗакрытиеМесяца", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Табличные части документа будут перезаполнены. Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		ЕстьОшибки = Ложь;
		ВыполнитьЗакрытиеМесяцаНаСервере(ЕстьОшибки);
		
		ТекстОповещения = НСтр("ru = 'Выполнен расчет налогов и удержаний'");
		ТекстПояснения = ?(ЕстьОшибки, 
			НСтр("ru = 'При расчете возникли ошибки'"), 
			НСтр("ru = 'При расчете ошибок не обнаружено'"));
		ПоказатьОповещениеПользователя(ТекстОповещения, , ТекстПояснения, БиблиотекаКартинок.Информация32);
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
		
		ЕстьОшибки = Ложь;
		ВыполнитьЗакрытиеМесяцаНаСервере(ЕстьОшибки);
		
		ТекстОповещения = НСтр("ru = 'Выполнен расчет налогов и удержаний'");
		ТекстПояснения = ?(ЕстьОшибки, 
			НСтр("ru = 'При расчете возникли ошибки'"), 
			НСтр("ru = 'При расчете ошибок не обнаружено'"));
		ПоказатьОповещениеПользователя(ТекстОповещения, , ТекстПояснения, БиблиотекаКартинок.Информация32);
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
&НаКлиенте
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
	
	Элементы.ГруппаИтогиДоп.Видимость = Элементы.НалогиПоЗарплатеПодробно.Пометка;
	
	Если Элементы.НалогиПоЗарплатеПодробно.Пометка Тогда 
		Элементы.НалогиПоЗарплатеГруппаСФ.Группировка = ГруппировкаКолонок.Вертикальная;
	Иначе 
		Элементы.НалогиПоЗарплатеГруппаСФ.Группировка = ГруппировкаКолонок.Горизонтальная;
	КонецЕсли;	
КонецПроцедуры // УстановитьВидимостьДоступностьЭлементов()

// Функция возвращает ответ пользователя о возможности записи/отмене проведения документа перед рассчетом
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
	Иначе
		Объект.Дата = ДатаДокумента;
		ЗаписатьНаСервере(РежимЗаписиДокумента.Запись);		
	КонецЕсли;	
	
	Возврат Истина;
КонецФункции // ЗаписатьДокументОтменивПроведение()

// Процедура - Записать на сервере
//
// Параметры:
//  Режим	 - 	 - 
//
&НаСервере
Процедура ЗаписатьНаСервере(Режим)
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.Записать(Режим);
	ЗначениеВРеквизитФормы(Документ, "Объект");
КонецПроцедуры // ЗаписатьНаСервере()

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
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область РедактированиеМесяцаСтрокой

&НаКлиенте
Процедура ПериодРегистрацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОповещениеЗавершения = Новый ОписаниеОповещения("ВводМесяцаОбработкаВыбораЗавершение", ЭтаФорма);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрокой",, ОповещениеЗавершения);
КонецПроцедуры

&НаКлиенте
Процедура ВводМесяцаОбработкаВыбораЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	Объект.Дата = КонецМесяца(Объект.ПериодРегистрации);
	ДатаПриИзменении(Элементы.Дата);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрокой", Модифицированность);
	Объект.Дата = КонецМесяца(Объект.ПериодРегистрации);
	ДатаПриИзменении(Элементы.Дата);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрокой", Направление, Модифицированность);
	Объект.Дата = КонецМесяца(Объект.ПериодРегистрации);
	ДатаПриИзменении(Элементы.Дата);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти
