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
	
	Если Параметры.Ключ.Пустая() Тогда
		УстановитьНачальныеСвойстваСубконтоШапки();
	КонецЕсли;	

	УстановитьУсловноеОформление();

	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);		
	
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

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	УстановитьНачальныеСвойстваСубконтоШапки();

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

// Процедура - обработчик события ПослеЗаписиНаСервере.
//
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)	
	
	УстановитьНачальныеСвойстваСубконтоШапки();
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	КонтрольВеденияУчета.ПослеЗаписиНаСервере(ТекущийОбъект);
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
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоШапкиПриИзмененииОрганизации(ЭтаФорма, Объект, ПараметрыУстановкиСвойствСубконтоДт(ЭтотОбъект, Объект.Организация));
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоШапкиПриИзмененииОрганизации(ЭтаФорма, Объект, ПараметрыУстановкиСвойствСубконтоКт(ЭтотОбъект, Объект.Организация));
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

// Процедура - обработчик события ПриИзменении поля ввода СчетДт.
//
&НаКлиенте
Процедура СчетДтПриИзменении(Элемент)	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоШапкиПриИзмененииСчета(
		ЭтотОбъект, Объект, ПараметрыУстановкиСвойствСубконтоДт(ЭтотОбъект, Объект.Организация));
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Субконто1.
//
&НаКлиенте
Процедура СубконтоДт1ПриИзменении(Элемент)
	
	ПриИзмененииСубконто(1, "Дт");
	
КонецПроцедуры

// Процедура - обработчик события НачалоВыбора поля ввода Субконто1.
//
&НаКлиенте
Процедура СубконтоДт1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка, "Дт");
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Субконто2.
//
&НаКлиенте
Процедура СубконтоДт2ПриИзменении(Элемент)
	
	ПриИзмененииСубконто(2, "Дт");
	
КонецПроцедуры

// Процедура - обработчик события НачалоВыбора поля ввода Субконто2.
//
&НаКлиенте
Процедура СубконтоДт2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка, "Дт");
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Субконто3.
//
&НаКлиенте
Процедура СубконтоДт3ПриИзменении(Элемент)
	
	ПриИзмененииСубконто(3, "Дт");
	
КонецПроцедуры

// Процедура - обработчик события НачалоВыбора поля ввода Субконто3.
//
&НаКлиенте
Процедура СубконтоДт3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка, "Дт");
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода СчетКт.
//
&НаКлиенте
Процедура СчетКтПриИзменении(Элемент)	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоШапкиПриИзмененииСчета(
		ЭтотОбъект, Объект, ПараметрыУстановкиСвойствСубконтоКт(ЭтотОбъект, Объект.Организация));
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Субконто1.
//
&НаКлиенте
Процедура СубконтоКт1ПриИзменении(Элемент)
	
	ПриИзмененииСубконто(1, "Кт");
	
КонецПроцедуры

// Процедура - обработчик события НачалоВыбора поля ввода Субконто1.
//
&НаКлиенте
Процедура СубконтоКт1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка, "Кт");
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Субконто2.
//
&НаКлиенте
Процедура СубконтоКт2ПриИзменении(Элемент)
	
	ПриИзмененииСубконто(2, "Кт");
	
КонецПроцедуры

// Процедура - обработчик события НачалоВыбора поля ввода Субконто2.
//
&НаКлиенте
Процедура СубконтоКт2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка, "Кт");
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Субконто3.
//
&НаКлиенте
Процедура СубконтоКт3ПриИзменении(Элемент)
	
	ПриИзмененииСубконто(3, "Кт");
	
КонецПроцедуры

// Процедура - обработчик события НачалоВыбора поля ввода Субконто3.
//
&НаКлиенте
Процедура СубконтоКт3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка, "Кт");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если Объект.Налоги.Количество() > 0 Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьТабличнуюЧастьНалоги", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Табличная часть документа будет заполнена. Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);	
	Иначе
		ЗаполнитьНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьТабличнуюЧастьНалоги(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Объект.Налоги.Очистить();
        ЗаполнитьНаСервере();
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

// Процедура - Установить пиктограмму комментария.
//
&НаКлиенте
Процедура УстановитьПиктограммуКомментария()
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// Только просмотр для первых 6-и строк.
	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "НалогиСуммаВыручки");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Налоги.НомерСтроки", ВидСравненияКомпоновкиДанных.МеньшеИлиРавно, 6);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НедоступныеДанныеЦвет);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	// Только просмотр для первых 7-14 строки.
	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "НалогиОбъемВоды");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Налоги.НомерСтроки", ВидСравненияКомпоновкиДанных.БольшеИлиРавно, 7);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НедоступныеДанныеЦвет);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ЗаполнитьНалоги();
	ЗначениеВРеквизитФормы(Документ, "Объект");
	Модифицированность = Истина;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииРаботаССубконто

&НаСервере
Процедура УстановитьНачальныеСвойстваСубконтоШапки()
	БухгалтерскийУчетКлиентСервер.УстановитьНачальныеСвойстваСубконтоШапки(ЭтаФорма, Объект, ПараметрыУстановкиСвойствСубконтоДт(ЭтотОбъект, Объект.Организация));
	БухгалтерскийУчетКлиентСервер.УстановитьНачальныеСвойстваСубконтоШапки(ЭтаФорма, Объект, ПараметрыУстановкиСвойствСубконтоКт(ЭтотОбъект, Объект.Организация));
КонецПроцедуры 

&НаКлиенте
Процедура ПриИзмененииСубконто(НомерСубконто, КлючСубконто)
	Если КлючСубконто = "Дт" Тогда 
		БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоШапкиПриИзмененииСубконто(
			ЭтотОбъект, Объект, НомерСубконто, ПараметрыУстановкиСвойствСубконтоДт(ЭтотОбъект, Объект.Организация));
	Иначе 
		БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоШапкиПриИзмененииСубконто(
			ЭтотОбъект, Объект, НомерСубконто, ПараметрыУстановкиСвойствСубконтоКт(ЭтотОбъект, Объект.Организация));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка, КлючСубконто)
	
	Если КлючСубконто = "Дт" Тогда 
		ДанныеОбъекта = БухгалтерскийУчетКлиентСервер.ДанныеУстановкиПараметровСубконто(
			Объект, 
			ПараметрыУстановкиСвойствСубконтоДт(ЭтотОбъект, Объект.Организация));
	Иначе 
		ДанныеОбъекта = БухгалтерскийУчетКлиентСервер.ДанныеУстановкиПараметровСубконто(
			Объект, 
			ПараметрыУстановкиСвойствСубконтоКт(ЭтотОбъект, Объект.Организация));
	КонецЕсли;
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыУстановкиСвойствСубконтоДт(Форма, Организация)

	Результат = БухгалтерскийУчетКлиентСервер.ПараметрыУстановкиСвойствСубконтоПоШаблону(
		"СубконтоДт", "СубконтоДт", "СчетДт");
	Результат.ДопРеквизиты.Вставить("Организация", Организация);
	
	Возврат Результат;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыУстановкиСвойствСубконтоКт(Форма, Организация)

	Результат = БухгалтерскийУчетКлиентСервер.ПараметрыУстановкиСвойствСубконтоПоШаблону(
		"СубконтоКт", "СубконтоКт", "СчетКт");
	Результат.ДопРеквизиты.Вставить("Организация", Организация);
	
	Возврат Результат;

КонецФункции

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
     ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
     ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
 
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
     ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
     ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

