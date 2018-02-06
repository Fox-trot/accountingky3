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
		ДатаДокумента = ТекущаяДатаСеанса();
	КонецЕсли;
	
	РезультатПроверки = СотрудникиФормы.ПроверитьВозможностьВнесенияКадровыхИзменений(Объект.Ссылка, Объект.Организация, Объект.ФизЛицо, Объект.ДатаУвольнения);
	ИзмененияВозможны = РезультатПроверки.ИзмененияВозможны;	
	
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
	
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

&НаКлиенте
Процедура ПризнакКомпенсацииОтпускаПриИзменении(Элемент)
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
	ПризнакКомпенсацииОтпускаПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПериодЗаКоторыйПредоставляетсяОтпускExtendedTooltipНажатие(Элемент)
	
	ТекстСообщения = НСтр("ru = 'В разработке. Справка По Отпускам Сотрудника'");
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.Физлицо");
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	Отказ = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Объект.ФизЛицо) Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнено поле ""Сотрудник""! Заполнение документа отменено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.ФизЛицо",,Отказ)		
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Объект.ДатаУвольнения) Тогда 
		ТекстСообщения = НСтр("ru = 'Не заполнено поле ""Дата увольнения""!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.ДатаУвольнения",,Отказ)		
	КонецЕсли;	
	
	Если Отказ Тогда 
		Возврат
	КонецЕсли;	
	
	Если НЕ ЗаписатьДокументОтменивПроведение() Тогда 
		Возврат;
	КонецЕсли;	
	
	Если Объект.НачисленияИУдержания.Количество() > 0 Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьТабличнуюЧасть", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Табличная часть документа будет очищена! Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		ЗаполнитьТабличнуюЧастьНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Рассчитать(Команда)
	Отказ = Ложь;
	
	Если Объект.НачисленияИУдержания.Количество() = 0  Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнена табличная часть! Расчет документа отменен.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.НачисленияИУдержания",,Отказ)		
	КонецЕсли;
	
	Если Отказ Тогда 
		Возврат
	КонецЕсли;	
	
	Если НЕ ЗаписатьДокументОтменивПроведение() Тогда 
		Возврат;
	КонецЕсли;	
	
	Если Объект.НачисленияИУдержания.Количество() > 0 Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросРассчитатьТабличнуюЧасть", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Табличная часть документа будет пересчитана! Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		РассчитатьТабличнуюЧастьНаСервере();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьТабличнуюЧасть(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Объект.НачисленияИУдержания.Очистить();
		ЗаполнитьТабличнуюЧастьНаСервере();
	КонецЕсли; 
КонецПроцедуры	

&НаКлиенте
Процедура ОтветНаВопросРассчитатьТабличнуюЧасть(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Объект.НачисленияИУдержания.Очистить();
		РассчитатьТабличнуюЧастьНаСервере();	
	КонецЕсли; 
КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость и доступность элементов.
//
&НаКлиенте
Процедура УстановитьВидимостьДоступностьЭлементов()
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДнейКомпенсацииУдержанияОтпуска",
		"Доступность",
		Объект.ПризнакКомпенсацииУдержанияОтпуска <> ПредопределенноеЗначение("Перечисление.КомпенсацияУдержаниеОтпускаПриУвольнении.НеИспользовать"));
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ВидРасчетаКомпенсацииУдержанияОсновногоОтпуска",
		"Доступность",
		Объект.ПризнакКомпенсацииУдержанияОтпуска <> ПредопределенноеЗначение("Перечисление.КомпенсацияУдержаниеОтпускаПриУвольнении.НеИспользовать"));
		
	// изменения возможны
	Элементы.ГруппаСообщенияОНевозможностиИзмененияДокумента.Видимость = НЕ ИзмененияВозможны;	
	Элементы.НачислениеУдержаниеЗаполнить.Доступность = ИзмененияВозможны;
	Элементы.НачислениеУдержаниеРассчитать.Доступность = ИзмененияВозможны;
	ТолькоПросмотр = НЕ ИзмененияВозможны;	
КонецПроцедуры // УстановитьВидимостьДоступностьЭлементов()

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьТипЗначенияВидаРасчета(Объект, ИмяПоляПризнака = "ПризнакКомпенсацииУдержанияОтпуска", ИмяПоляВидРасчета = "ВидРасчета")
	
	Если Объект[ИмяПоляПризнака] = ПредопределенноеЗначение("Перечисление.КомпенсацияУдержаниеОтпускаПриУвольнении.КомпенсироватьНеИспользованные") Тогда
		Если ТипЗнч(Объект[ИмяПоляВидРасчета]) <> Тип("ПланВидовРасчетаСсылка.ВидыНачислений") Тогда
			Объект[ИмяПоляВидРасчета] = ПредопределенноеЗначение("ПланВидовРасчета.ВидыНачислений.ПустаяСсылка");
		КонецЕсли;
	Иначе 	
		Если ТипЗнч(Объект[ИмяПоляВидРасчета]) <> Тип("ПланВидовРасчетаСсылка.ВидыУдержаний") Тогда
			Объект[ИмяПоляВидРасчета]  = ПредопределенноеЗначение("ПланВидовРасчета.ВидыУдержаний.ПустаяСсылка");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьОтметкуНезаполненногоДнейКомпенсацииУдержанияОтпуска()
	
	АвтоОтметкаНезаполненного = Объект.ПризнакКомпенсацииУдержанияОтпуска <> Перечисления.КомпенсацияУдержаниеОтпускаПриУвольнении.НеИспользовать;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДнейКомпенсацииУдержанияОтпуска", "АвтоОтметкаНезаполненного", АвтоОтметкаНезаполненного); 
	Если Не АвтоОтметкаНезаполненного Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДнейКомпенсацииУдержанияОтпуска", "ОтметкаНезаполненного", Ложь); 
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

&НаСервере
Процедура ПризнакКомпенсацииОтпускаПриИзмененииНаСервере()
	УстановитьТипЗначенияВидаРасчета(Объект);
	УстановитьОтметкуНезаполненногоДнейКомпенсацииУдержанияОтпуска();
КонецПроцедуры

// Функция возвращает ответ пользователя о возможности записи/отмене проведения документа перед рассчетом
//
// Параметры:
//  Действие  - Строка - действие, при котором выполняется проверка
// Возвращаемое значение:
//   Булево - 
//
&НаКлиенте
Функция ЗаписатьДокументОтменивПроведение()
	Если Объект.Проведен Тогда
		ЗаписатьНаСервере(РежимЗаписиДокумента.ОтменаПроведения);		
	ИначеЕсли Модифицированность 
		Или ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Дата = ДатаДокумента;
		ЗаписатьНаСервере(РежимЗаписиДокумента.Запись);		
	КонецЕсли;	
	
	Возврат Истина;
КонецФункции // ЗаписатьДокументОтменивПроведение()

&НаСервере
Процедура ЗаписатьНаСервере(Режим)
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.Записать(Режим);
	ЗначениеВРеквизитФормы(Документ, "Объект");
КонецПроцедуры // ЗаписатьНаСервере()

&НаСервере
Процедура ЗаполнитьТабличнуюЧастьНаСервере()
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ЗаполнитьТабличнуюЧасть();
	ЗначениеВРеквизитФормы(Документ, "Объект");
КонецПроцедуры // ЗаполнитьТабличнуюЧастьНаСервере()

// Процедура рассчитывает табличную часть
//
&НаСервере
Процедура РассчитатьТабличнуюЧастьНаСервере()
	
КонецПроцедуры // РассчитатьТабличнуюЧастьНаСервере()

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

