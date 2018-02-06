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
	
	Если Объект.ЗанимаемыхСтавок = 0 Тогда 
		Объект.ЗанимаемыхСтавок = 1;	
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(Объект.ФизЛицо) Тогда 
		ЗаполнитьПоСотруднику();
	КонецЕсли;
	
	РезультатПроверки = СотрудникиФормы.ПроверитьВозможностьВнесенияКадровыхИзменений(Объект.Ссылка, Объект.Организация, Объект.ФизЛицо, ДатаДокумента);
	ИзмененияВозможны = РезультатПроверки.ИзмененияВозможны;	
	
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
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
	БухгалтерскийУчетВызовСервера.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
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

// Процедура - обработчик события ПриИзменении поля ввода Физлицо.
//
&НаКлиенте
Процедура ФизлицоПриИзменении(Элемент)
	ЗаполнитьПоСотруднику();

	Объект.Начисления.Очистить();
	Объект.Удержания.Очистить();
	
	ЗаполнитьНачисленияНаСервере();
	ЗаполнитьУдержанияНаСервере();
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();           
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Подразделение.
//
&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Должность.
//
&НаКлиенте
Процедура ДолжностьПриИзменении(Элемент)
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();   	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Размер.
//
&НаКлиенте
Процедура РазмерПриИзменении(Элемент)
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура НачисленияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		// получаем текущую строку
		СтрокаТабличнойЧасти = Элемент.ТекущиеДанные;
		
		// не удалось получить- возвращаемся
		Если СтрокаТабличнойЧасти = Неопределено Тогда 
			Возврат;
		КонецЕсли;
		
		СтрокаТабличнойЧасти.ВидДействия = ПредопределенноеЗначение("Перечисление.ВидыДействияНачисленийУдержаний.Начать");
	КонецЕсли;			
КонецПроцедуры

&НаКлиенте
Процедура УдержанияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		// получаем текущую строку
		СтрокаТабличнойЧасти = Элемент.ТекущиеДанные;
		
		// не удалось получить- возвращаемся
		Если СтрокаТабличнойЧасти = Неопределено Тогда 
			Возврат;
		КонецЕсли;

	КонецЕсли;			
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	Если НЕ ЗначениеЗаполнено(Объект.ФизЛицо) Тогда 
		ТекстСообщения = НСтр("ru = 'Не заполнено поле ""Сотрудник"".'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.ФизЛицо");
		Возврат;
	КонецЕсли;	
	
	Ответ = Неопределено;
	ТекстВороса = СтрШаблон(НСтр("ru = 'Документ будет перезаполнен по сотруднику ""%1""! Продолжить выполнение операции?'"),	Объект.ФизЛицо);	
	ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьЗавершение", ЭтотОбъект), 
	ТекстВороса, РежимДиалогаВопрос.ДаНет, 0);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНачисления(Команда)
	Если Объект.Начисления.Количество() > 0 Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьНачисления", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Список начислений будет перезаполнен! Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		ЗаполнитьНачисленияНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьУдержания(Команда)
	Если Объект.Начисления.Количество() > 0 Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьУдержания", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Список удержаний будет перезаполнен! Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		ЗаполнитьУдержанияНаСервере();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Процедура ЗаполнитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
    Ответ = Результат;
    Если Ответ = КодВозвратаДиалога.Да Тогда
        ЗаполнитьПоСотруднику();
		
		Объект.Начисления.Очистить();
		Объект.Удержания.Очистить();
		
		ЗаполнитьНачисленияНаСервере();
		ЗаполнитьУдержанияНаСервере();
		
		// Установить видимость и доступность элементов формы
		УстановитьВидимостьДоступностьЭлементов();           
    КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьНачисления(Результат, ДополнительныеПараметры) Экспорт
    Ответ = Результат;
    Если Ответ = КодВозвратаДиалога.Да Тогда
        ЗаполнитьНачисленияНаСервере();		
    КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьУдержания(Результат, ДополнительныеПараметры) Экспорт
    Ответ = Результат;
    Если Ответ = КодВозвратаДиалога.Да Тогда
        ЗаполнитьУдержанияНаСервере();		
    КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость и доступность элементов.
//
&НаКлиенте
Процедура УстановитьВидимостьДоступностьЭлементов()
	// изменения возможны
	Элементы.ГруппаСообщенияОНевозможностиИзмененияДокумента.Видимость = НЕ ИзмененияВозможны;	
	Элементы.Заполнить.Доступность = ИзмененияВозможны; 
	Элементы.НачисленияЗаполнитьНачисления.Доступность = ИзмененияВозможны; 
	Элементы.УдержанияЗаполнитьУдержания.Доступность = ИзмененияВозможны; 
	ТолькоПросмотр = НЕ ИзмененияВозможны;
КонецПроцедуры // УстановитьВидимостьДоступностьЭлементов()

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

// Заполнение реквизитов объекта и формы
//
&НаСервере
Процедура ЗаполнитьПоСотруднику(ЗаполнитьРеквизиты = Ложь)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПлановыеНачисленияНачалоСрезПоследних.ВидРасчета,
		|	ПлановыеНачисленияНачалоСрезПоследних.Размер
		|ПОМЕСТИТЬ ВременнаяТаблицаСрезПлановыеНачисленияНачалоАктуально
		|ИЗ
		|	РегистрСведений.ПлановыеНачисленияНачало.СрезПоследних(
		|			&Период,
		|			Организация = &Организация
		|				И ФизЛицо = &ФизЛицо
		|				И НЕ Регистратор = &Ссылка) КАК ПлановыеНачисленияНачалоСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПлановыеНачисленияОкончание.СрезПоследних(
		|				&Период,
		|				Организация = &Организация
		|					И ФизЛицо = &ФизЛицо
		|					И НЕ Регистратор = &Ссылка) КАК ПлановыеНачисленияОкончаниеСрезПоследних
		|		ПО ПлановыеНачисленияНачалоСрезПоследних.Организация = ПлановыеНачисленияОкончаниеСрезПоследних.Организация
		|			И ПлановыеНачисленияНачалоСрезПоследних.ФизЛицо = ПлановыеНачисленияОкончаниеСрезПоследних.ФизЛицо
		|			И ПлановыеНачисленияНачалоСрезПоследних.ВидРасчета = ПлановыеНачисленияОкончаниеСрезПоследних.ВидРасчета
		|			И ПлановыеНачисленияНачалоСрезПоследних.Регистратор = ПлановыеНачисленияОкончаниеСрезПоследних.ДокументСсылка
		|ГДЕ
		|	ПлановыеНачисленияНачалоСрезПоследних.Основной
		|	И ПлановыеНачисленияОкончаниеСрезПоследних.Организация ЕСТЬ NULL
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СотрудникиСрезПоследних.Подразделение,
		|	СотрудникиСрезПоследних.Должность,
		|	СотрудникиСрезПоследних.ЗанимаемыхСтавок,
		|	СотрудникиСрезПоследних.ГрафикРаботы,
		|	ПлановыеНачисленияНачалоСрезПоследних.ВидРасчета,
		|	ПлановыеНачисленияНачалоСрезПоследних.Размер
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(
		|			&Период,
		|			Организация = &Организация
		|				И ФизЛицо = &ФизЛицо
		|				И НЕ Регистратор = &Ссылка) КАК СотрудникиСрезПоследних
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаСрезПлановыеНачисленияНачалоАктуально КАК ПлановыеНачисленияНачалоСрезПоследних
		|		ПО (ИСТИНА)";
	Запрос.УстановитьПараметр("Период", ДатаДокумента);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("ФизЛицо", Объект.ФизЛицо);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда 
		ТекстСообщения = НСтр("ru = 'Нет сведений по выбранному сотруднику!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.Сотрудник");
		Возврат;		
	КонецЕсли;	
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	ВыборкаДетальныеЗаписи.Следующий();
	
	Если ЗаполнитьРеквизиты Тогда 
		ЗаполнитьЗначенияСвойств(Объект, ВыборкаДетальныеЗаписи);
	КонецЕсли;	
	
	// Реквизиты формы
	ПрежнееПодразделение = ВыборкаДетальныеЗаписи.Подразделение;	
	ПрежняяДолжность = ВыборкаДетальныеЗаписи.Должность;	
	ПрежнийГрафикРаботы = ВыборкаДетальныеЗаписи.ГрафикРаботы;	
	ПрежнееКоличествоЗанимаемыхСтавок = ВыборкаДетальныеЗаписи.ЗанимаемыхСтавок;	
	ПрежнийРазмер = ВыборкаДетальныеЗаписи.Размер;
	ПрежнийВидРасчета = ВыборкаДетальныеЗаписи.ВидРасчета;
КонецПроцедуры // ЗаполнитьПоСотруднику()

// Заполняет список начислений
//
&НаСервере
Процедура ЗаполнитьНачисленияНаСервере()
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПлановыеНачисленияНачалоСрезПоследних.ВидРасчета,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыДействияНачисленийУдержаний.НеИзменять) КАК ВидДействия,
		|	ПлановыеНачисленияНачалоСрезПоследних.Размер
		|ИЗ
		|	РегистрСведений.ПлановыеНачисленияНачало.СрезПоследних(
		|			&Период,
		|			Организация = &Организация
		|				И ФизЛицо = &ФизЛицо
		|				И НЕ Регистратор = &Ссылка) КАК ПлановыеНачисленияНачалоСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПлановыеНачисленияОкончание.СрезПоследних(
		|				&Период,
		|				Организация = &Организация
		|					И ФизЛицо = &ФизЛицо
		|					И НЕ Регистратор = &Ссылка) КАК ПлановыеНачисленияОкончаниеСрезПоследних
		|		ПО ПлановыеНачисленияНачалоСрезПоследних.Организация = ПлановыеНачисленияОкончаниеСрезПоследних.Организация
		|			И ПлановыеНачисленияНачалоСрезПоследних.ФизЛицо = ПлановыеНачисленияОкончаниеСрезПоследних.ФизЛицо
		|			И ПлановыеНачисленияНачалоСрезПоследних.ВидРасчета = ПлановыеНачисленияОкончаниеСрезПоследних.ВидРасчета
		|			И ПлановыеНачисленияНачалоСрезПоследних.Регистратор = ПлановыеНачисленияОкончаниеСрезПоследних.ДокументСсылка
		|ГДЕ
		|	НЕ ПлановыеНачисленияНачалоСрезПоследних.Основной
		|	И ПлановыеНачисленияОкончаниеСрезПоследних.Организация ЕСТЬ NULL
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПлановыеНачисленияНачалоСрезПоследних.ВидРасчета.РеквизитДопУпорядочивания";
	Запрос.УстановитьПараметр("Период", Объект.Период);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("ФизЛицо", Объект.ФизЛицо);
	
	Объект.Начисления.Загрузить(Запрос.Выполнить().Выгрузить());
КонецПроцедуры // ЗаполнитьНачисленияНаСервере()

// Заполняет список удержаний
//
&НаСервере
Процедура ЗаполнитьУдержанияНаСервере()
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПлановыеУдержанияНачалоСрезПоследних.ВидРасчета,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыДействияНачисленийУдержаний.НеИзменять) КАК ВидДействия,
		|	ПлановыеУдержанияНачалоСрезПоследних.Размер
		|ИЗ
		|	РегистрСведений.ПлановыеУдержанияНачало.СрезПоследних(
		|			&Период,
		|			Организация = &Организация
		|				И ФизЛицо = &ФизЛицо
		|				И НЕ Регистратор = &Ссылка) КАК ПлановыеУдержанияНачалоСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПлановыеУдержанияОкончание.СрезПоследних(
		|				&Период,
		|				Организация = &Организация
		|					И ФизЛицо = &ФизЛицо
		|					И НЕ Регистратор = &Ссылка) КАК ПлановыеУдержанияОкончаниеСрезПоследних
		|		ПО ПлановыеУдержанияНачалоСрезПоследних.Организация = ПлановыеУдержанияОкончаниеСрезПоследних.Организация
		|			И ПлановыеУдержанияНачалоСрезПоследних.ФизЛицо = ПлановыеУдержанияОкончаниеСрезПоследних.ФизЛицо
		|			И ПлановыеУдержанияНачалоСрезПоследних.ВидРасчета = ПлановыеУдержанияОкончаниеСрезПоследних.ВидРасчета
		|			И ПлановыеУдержанияНачалоСрезПоследних.Регистратор = ПлановыеУдержанияОкончаниеСрезПоследних.ДокументСсылка
		|ГДЕ
		|	ПлановыеУдержанияОкончаниеСрезПоследних.Организация ЕСТЬ NULL
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПлановыеУдержанияНачалоСрезПоследних.ВидРасчета.РеквизитДопУпорядочивания";
	Запрос.УстановитьПараметр("Период", Объект.Период);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("ФизЛицо", Объект.ФизЛицо);
	
	Объект.Удержания.Загрузить(Запрос.Выполнить().Выгрузить());
КонецПроцедуры // ЗаполнитьУдержанияНаСервере()

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

