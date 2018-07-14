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
		
	РезультатПроверки = СотрудникиФормы.ПроверитьВозможностьВнесенияКадровыхИзменений(Объект.Ссылка, Объект.Организация, Объект.ФизЛицо, Объект.Период);
	ИзмененияВозможны = РезультатПроверки.ИзмененияВозможны;	
	
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
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
	
КонецПроцедуры // ПриЧтенииНаСервере()

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
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
	БухгалтерскийУчетВызовСервера.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
	
	ЗаполнитьОбщийСтаж();	

	ЗаполнитьПоШтатномуРасписанию();
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

// Процедура - обработчик события ПриИзменении поля ввода Период.
//
&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	Объект.ИспытательныйСрок = ДобавитьМесяц(Объект.Период, 3);
	ЗаполнитьОбщийСтаж();	
КонецПроцедуры

&НаКлиенте
Процедура ФизлицоПриИзменении(Элемент)
	ЗаполнитьОбщийСтаж();	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	ЗаполнитьПоШтатномуРасписанию();	
	
КонецПроцедуры

&НаКлиенте
Процедура ДолжностьПриИзменении(Элемент)
	
	ЗаполнитьПоШтатномуРасписанию();	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость и доступность элементов.
//
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	Элементы.ГруппаСообщенияОНевозможностиИзмененияДокумента.Видимость = НЕ ИзмененияВозможны;	
	ТолькоПросмотр = НЕ ИзмененияВозможны;
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

// Процедура заполнения по данным штатного расписания
//
&НаСервере
Процедура ЗаполнитьПоШтатномуРасписанию()

	Если Константы.ФункциональнаяОпцияВестиШтатноеРасписание.Получить()
		И ЗначениеЗаполнено(Объект.Организация)
		И ЗначениеЗаполнено(Объект.Должность)
		И ЗначениеЗаполнено(Объект.Подразделение) Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("Организация", 	Объект.Организация);
		Отбор.Вставить("Подразделение", Объект.Подразделение);
		Отбор.Вставить("Должность", 	Объект.Должность);
		
		СтруктураДанных = РегистрыСведений.ШтатноеРасписание.ПолучитьПоследнее(Объект.Дата, Отбор); 
		
		// Проверка наличия данных.
		Если СтруктураДанных.Свойство("ВидНачисления") Тогда
			Объект.ВидРасчета 					= СтруктураДанных.ВидНачисления;
			Объект.Размер 						= СтруктураДанных.МинимальнаяТарифнаяСтавка;
		КонецЕсли;	
	КонецЕсли;	

КонецПроцедуры

// Процедура - Заполнить общий стаж
// При повторном приеме есть возможность заполнить стаж.
&НаСервере
Процедура ЗаполнитьОбщийСтаж()
	
	// Дата предыдущего увольнения.
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СотрудникиСрезПоследних.Период КАК Период
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(
		|			&Период,
		|			Организация = &Организация
		|				И ФизЛицо = &ФизЛицо
		|				И ВидСобытия = Значение(Перечисление.ВидыКадровыхСобытий.Увольнение)) КАК СотрудникиСрезПоследних";
	Запрос.УстановитьПараметр("Период", Объект.Период);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("ФизЛицо", Объект.ФизЛицо);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда 
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		ВыборкаДетальныеЗаписи.Следующий();
	
		СведенияОСтаже = ПроведениеРасчетовПоЗарплатеСервер.СведенияОСтажеСотрудника(ВыборкаДетальныеЗаписи.Период, Объект.Организация, Объект.ФизЛицо);
		
		Объект.ОбщийСтажЛет = СведенияОСтаже.Лет;
		Объект.ОбщийСтажМесяцев = СведенияОСтаже.Месяцев;
		Объект.ОбщийСтажДней = СведенияОСтаже.Дней;
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьОбщийСтаж()

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



