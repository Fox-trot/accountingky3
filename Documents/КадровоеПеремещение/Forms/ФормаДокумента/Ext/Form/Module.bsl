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
	
	Если ЗначениеЗаполнено(Объект.ФизЛицо) Тогда 
		ЗаполнитьПоСотруднику();
	КонецЕсли;
	
	ИзмененияВозможны = ПроверитьВозможностьВнесенияКадровыхИзменений(Объект.Ссылка, Объект.Организация, Объект.ФизЛицо, Объект.Период);
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();

	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();

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
	
	ЗаполнитьПоШтатномуРасписанию();
	
	ИзмененияВозможны = ПроверитьВозможностьВнесенияКадровыхИзменений(Объект.Ссылка, Объект.Организация, Объект.ФизЛицо, Объект.Период);
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
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

// Процедура - обработчик события ПриИзменении поля ввода ФизЛицо.
//
&НаКлиенте
Процедура ФизЛицоПриИзменении(Элемент)
	ЗаполнитьПоСотруднику(Истина);
	Объект.Начисления.Очистить();
	ЗаполнитьНачисленияНаСервере();
	
	ИзмененияВозможны = ПроверитьВозможностьВнесенияКадровыхИзменений(Объект.Ссылка, Объект.Организация, Объект.ФизЛицо, Объект.Период);

	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();           
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	ИзмененияВозможны = ПроверитьВозможностьВнесенияКадровыхИзменений(Объект.Ссылка, Объект.Организация, Объект.ФизЛицо, Объект.Период);

	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();           
КонецПроцедуры

&НаКлиенте
Процедура НачисленияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		СтрокаТабличнойЧасти = Элемент.ТекущиеДанные;
		СтрокаТабличнойЧасти.ВидДействия = ПредопределенноеЗначение("Перечисление.ВидыДействияНачисленийУдержаний.Начать");
		СтрокаТабличнойЧасти.Валюта = ВалютаРегламентированногоУчета;
	КонецЕсли;			
КонецПроцедуры

&НаКлиенте
Процедура НачисленияВидНачисленияПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Начисления.ТекущиеДанные;
	
	// Сброс валюты для процентных видов начислений.
	СпособРасчета = ПолучитьСпособРасчетаПоВидуНачисления(СтрокаТабличнойЧасти.ВидРасчета);
	Если СпособРасчета = ПредопределенноеЗначение("Перечисление.СпособыРасчетаНачислений.Процентом")
		Или СпособРасчета = ПредопределенноеЗначение("Перечисление.СпособыРасчетаНачислений.ГодоваяПремия") Тогда 
		
		СтрокаТабличнойЧасти.Валюта = ВалютаРегламентированногоУчета;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ДолжностьПриИзменении(Элемент)
	
	ЗаполнитьПоШтатномуРасписанию();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	ЗаполнитьПоШтатномуРасписанию();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицФормы

&НаКлиенте
Процедура НачисленияВидДействияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтрокаТабличнойЧасти = Элементы.Начисления.ТекущиеДанные;
	
	МассивПараметровВыбора = Новый Массив;
	Если НЕ СтрокаТабличнойЧасти.ДобавленоАвтоматически Тогда 
		МассивПараметровВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ВидыДействияНачисленийУдержаний.Начать"));	
	Иначе 
		МассивПараметровВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ВидыДействияНачисленийУдержаний.Прекратить"));
		МассивПараметровВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ВидыДействияНачисленийУдержаний.НеИзменять"));
	КонецЕсли;
	// Формирование параметра выбора.
	НовыйПараметр = Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(МассивПараметровВыбора));
	// Добавление параметра выбора.
	НовыйМассив = Новый Массив();
	НовыйМассив.Добавить(НовыйПараметр);
	НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
	Элементы.НачисленияВидДействия.ПараметрыВыбора = НовыеПараметры;
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

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Процедура ЗаполнитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
    Ответ = Результат;
    Если Ответ = КодВозвратаДиалога.Да Тогда
        ЗаполнитьПоСотруднику(Истина);
		
		Объект.Начисления.Очистить();
		
		ЗаполнитьНачисленияНаСервере();
		
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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция - Проверить возможность внесения кадровых изменений
//
&НаСервереБезКонтекста
Функция ПроверитьВозможностьВнесенияКадровыхИзменений(ДокументСсылка, Организация, ФизЛицо, ДатаИзменений)
	РезультатПроверки = СотрудникиФормы.ПроверитьВозможностьВнесенияКадровыхИзменений(ДокументСсылка, Организация, ФизЛицо, ДатаИзменений);
	Возврат РезультатПроверки.ИзмененияВозможны;
КонецФункции 

// Процедура устанавливает видимость и доступность элементов.
//
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	Элементы.ГруппаСообщенияОНевозможностиИзмененияДокумента.Видимость = НЕ ИзмененияВозможны;	
	Элементы.Заполнить.Доступность = ИзмененияВозможны; 
	Элементы.НачисленияЗаполнитьНачисления.Доступность = ИзмененияВозможны; 
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

// Заполнение реквизитов объекта и формы
//
&НаСервере
Процедура ЗаполнитьПоСотруднику(ЗаполнитьРеквизиты = Ложь)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПлановыеНачисленияНачалоСрезПоследних.ВидРасчета,
		|	ПлановыеНачисленияНачалоСрезПоследних.Валюта,
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
		|	ПлановыеНачисленияНачалоСрезПоследних.Валюта,
		|	ПлановыеНачисленияНачалоСрезПоследних.Размер
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(
		|			&Период,
		|			Организация = &Организация
		|				И ФизЛицо = &ФизЛицо
		|				И НЕ Регистратор = &Ссылка) КАК СотрудникиСрезПоследних
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаСрезПлановыеНачисленияНачалоАктуально КАК ПлановыеНачисленияНачалоСрезПоследних
		|		ПО (ИСТИНА)";
	Запрос.УстановитьПараметр("Период", Объект.Период);
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
	
	// Реквизиты формы.
	ПрежнееПодразделение = ВыборкаДетальныеЗаписи.Подразделение;	
	ПрежняяДолжность = ВыборкаДетальныеЗаписи.Должность;	
	ПрежнийГрафикРаботы = ВыборкаДетальныеЗаписи.ГрафикРаботы;	
	ПрежнееКоличествоЗанимаемыхСтавок = ВыборкаДетальныеЗаписи.ЗанимаемыхСтавок;	
	ПрежнийРазмер = ВыборкаДетальныеЗаписи.Размер;
	ПрежнийВидРасчета = ВыборкаДетальныеЗаписи.ВидРасчета;
	ПрежняяВалюта = ВыборкаДетальныеЗаписи.Валюта;
КонецПроцедуры // ЗаполнитьПоСотруднику()

// Заполняет список начислений
//
&НаСервере
Процедура ЗаполнитьНачисленияНаСервере()
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПлановыеНачисленияНачалоСрезПоследних.ВидРасчета КАК ВидРасчета,
		|	ПлановыеНачисленияНачалоСрезПоследних.Валюта КАК Валюта,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыДействияНачисленийУдержаний.НеИзменять) КАК ВидДействия,
		|	ПлановыеНачисленияНачалоСрезПоследних.Размер КАК Размер,
		|	ИСТИНА КАК ДобавленоАвтоматически
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
		|	ПлановыеНачисленияНачалоСрезПоследних.ВидРасчета.Порядок";
	Запрос.УстановитьПараметр("Период", Объект.Период);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("ФизЛицо", Объект.ФизЛицо);
	
	Объект.Начисления.Загрузить(Запрос.Выполнить().Выгрузить());
КонецПроцедуры // ЗаполнитьНачисленияНаСервере()

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
			Объект.ВидРасчета = СтруктураДанных.ВидНачисления;
			Объект.Размер = СтруктураДанных.МинимальнаяТарифнаяСтавка;
		КонецЕсли;	
	КонецЕсли;	

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСпособРасчетаПоВидуНачисления(ВидРасчета)
	Возврат ВидРасчета.СпособРасчета;
КонецФункции // ПолучитьСпособРасчетаПоВидуНачисления()

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

