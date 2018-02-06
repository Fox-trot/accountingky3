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
		
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцУдержанияСтрокой");
	
	ВидРасчета = Объект.ВидРасчета;
	
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

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцУдержанияСтрокой");
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменений
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменений
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры // ПриЧтенииНаСервере()

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПодборСотрудникаПроизведен" 
		И ЗначениеЗаполнено(Параметр) 
		// Проверка на владельца формы
		И Источник <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000")
		И Источник = УникальныйИдентификатор Тогда
		
		АдресЗапасовВХранилище = Параметр;
		ПолучитьРезультатПодбораИзХранилища(АдресЗапасовВХранилище, "Удержания");
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
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Организация.
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	// Обработка события изменения организации.
	Объект.Номер = "";
	БухгалтерскийУчетВызовСервера.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ВидУдержанияВСпискеПриИзменении(Элемент)
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ВидУдержанияПриИзменении(Элемент)
	Если Объект.Удержания.Количество() > 0 Тогда 
		ЗаполнитьВидРасчета();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РазмерПриИзменении(Элемент)
	Если Объект.Удержания.Количество() > 0 Тогда 
		ЗаполнитьРазмер();
	КонецЕсли;
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

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУдержания

&НаКлиенте
Процедура УдержанияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбработкаПодбораНаСервере(ВыбранноеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура УдержанияФизЛицоПриИзменении(Элемент)
	// получаем текущую строку
	СтрокаТабличнойЧасти = Элементы.Удержания.ТекущиеДанные;
	
	// не удалось получить- возвращаемся
	Если СтрокаТабличнойЧасти = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДополнитьСтрокиНаСервере(СтрокаТабличнойЧасти.ФизЛицо);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодборСотрудников(Команда)
	СотрудникиКлиент.ОткрытьПодбор(ЭтаФорма, "Удержания");  
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	Если Объект.Удержания.Количество() > 0 Тогда 
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
	
	Если Объект.Удержания.Количество() = 0  Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнена табличная часть ""Удержания""! Расчет документа отменен.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.Удержания",,Отказ)		
	КонецЕсли;
	
	Для Каждого СтрокаТабличнойЧасти Из Объект.Удержания Цикл 
		// Вид расчета
		Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.ВидРасчета) Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Не заполнен вид удержания в строке №%1! Расчет документа отменен.'"), СтрокаТабличнойЧасти.НомерСтроки);
			ПолеСообщения = СтрШаблон("Объект.Удержания[%1].ВидРасчета", СтрокаТабличнойЧасти.НомерСтроки-1);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,ПолеСообщения,,Отказ);		
		КонецЕсли;
		
		// Размер
		Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Размер) Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Не заполнен размер в строке №%1! Расчет документа отменен.'"), СтрокаТабличнойЧасти.НомерСтроки);
			ПолеСообщения = СтрШаблон("Объект.Удержания[%1].Размер", СтрокаТабличнойЧасти.НомерСтроки-1);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,ПолеСообщения,,Отказ);		
		КонецЕсли;
	КонецЦикла;
	
	Если Отказ
		Или НЕ ЗаписатьДокументОтменивПроведение() Тогда 
		Возврат;
	КонецЕсли;	
	
	Если Объект.Удержания.Количество() > 0 Тогда 
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
		ЗаполнитьТабличнуюЧастьНаСервере();
	КонецЕсли; 
КонецПроцедуры	

&НаКлиенте
Процедура ОтветНаВопросРассчитатьТабличнуюЧасть(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		РассчитатьТабличнуюЧастьНаСервере();	
	КонецЕсли; 
КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость и доступность элементов.
//
&НаКлиенте
Процедура УстановитьВидимостьДоступностьЭлементов()
	Элементы.ГруппаВидРасчетаРазмер.Видимость = НЕ Объект.ВидУдержанияВСписке; 
	Элементы.УдержанияВидУдержания.Видимость = Объект.ВидУдержанияВСписке; 
	Элементы.УдержанияРазмер.Видимость = Объект.ВидУдержанияВСписке; 
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
	Объект.Удержания.Очистить();

	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ЗаполнитьТабличнуюЧасть();
	ЗначениеВРеквизитФормы(Документ, "Объект");
КонецПроцедуры // ЗаполнитьТабличнуюЧастьНаСервере()

&НаКлиенте
Процедура ЗаполнитьВидРасчета()
	Для Каждого СтрокаТабличнойЧасти Из Объект.Удержания Цикл 
		СтрокаТабличнойЧасти.ВидРасчета = Объект.ВидРасчета;		
	КонецЦикла;	
КонецПроцедуры // ЗаполнитьВидУдержания()

&НаКлиенте
Процедура ЗаполнитьРазмер()
	Для Каждого СтрокаТабличнойЧасти Из Объект.Удержания Цикл 
		СтрокаТабличнойЧасти.Размер = Объект.Размер;		
	КонецЦикла;	
КонецПроцедуры // ЗаполнитьРазмер()

&НаСервере
Процедура РассчитатьТабличнуюЧастьНаСервере()
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.РассчитатьТабличнуюЧасть();
	ЗначениеВРеквизитФормы(Документ, "Объект");
КонецПроцедуры // ЗаполнитьТабличнуюЧастьНаСервере()

&НаСервере
Процедура ОбработкаПодбораНаСервере(Сотрудники)
	
	Для Каждого ФизЛицо Из Сотрудники Цикл
		СтрокиТабличнойЧасти = Объект.Удержания.НайтиСтроки(Новый Структура("ФизЛицо", ФизЛицо));
		
		Если СтрокиТабличнойЧасти.Количество() = 0 Тогда
			СтрокаТабличнойЧасти = Объект.Удержания.Добавить();
			СтрокаТабличнойЧасти.ФизЛицо = ФизЛицо;
		КонецЕсли;
	КонецЦикла;
	
	ДополнитьСтрокиНаСервере(Сотрудники);
КонецПроцедуры

// Процедура получает результат подбора из временного хранилища
//
&НаСервере
Процедура ПолучитьРезультатПодбораИзХранилища(АдресЗапасовВХранилище, ИмяТабличнойЧасти)
	ТаблицаДляЗагрузки = ПолучитьИзВременногоХранилища(АдресЗапасовВХранилище);
	
	МассивФизЛиц = Новый Массив;
	
	Для Каждого СтрокаЗагрузки Из ТаблицаДляЗагрузки Цикл
		НайденныеСтроки = Объект[ИмяТабличнойЧасти].НайтиСтроки(Новый Структура("ФизЛицо", СтрокаЗагрузки.ФизЛицо));
		
		Если НайденныеСтроки.Количество() > 0 Тогда 
			Продолжить;
		КонецЕсли;	
		
		СтрокаТабличнойЧасти = Объект[ИмяТабличнойЧасти].Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаЗагрузки);
		МассивФизЛиц.Добавить(СтрокаТабличнойЧасти.ФизЛицо);
	КонецЦикла;
	
	ДополнитьСтрокиНаСервере(МассивФизЛиц);
КонецПроцедуры // ПолучитьЗапасыИзХранилища()

// Процедура заполняет строки
//
// Параметры:
//  Сотрудники  - Массив - массив физ.лиц, по которым нужно заполнить строки
//
&НаСервере
Процедура ДополнитьСтрокиНаСервере(Сотрудники)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СотрудникиСрезПоследних.ФизЛицо,
		|	СотрудникиСрезПоследних.Должность,
		|	СотрудникиСрезПоследних.Подразделение,
		|	&НачалоПериода КАК ДатаНачала,
		|	&КонецПериода КАК ДатаОкончания,
		|	СотрудникиСрезПоследних.ГрафикРаботы
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(
		|			&КонецПериода,
		|			Организация = &Организация
		|				И ФизЛицо В (&Сотрудники)) КАК СотрудникиСрезПоследних";
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("НачалоПериода", Объект.ПериодРегистрации);
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(Объект.ПериодРегистрации));
	Запрос.УстановитьПараметр("Сотрудники", Сотрудники);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтрокиТабличнойЧасти = Объект.Удержания.НайтиСтроки(Новый Структура("ФизЛицо", ВыборкаДетальныеЗаписи.ФизЛицо));
		
		Для Каждого СтрокаТабличнойЧасти Из СтрокиТабличнойЧасти Цикл
			ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ВыборкаДетальныеЗаписи);			
		КонецЦикла;		
	КонецЦикла;    
КонецПроцедуры // ДополнитьСтрокиНаСервере()

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
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ПериодРегистрации", "МесяцУдержанияСтрокой");
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцУдержанияСтрокой", Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцУдержанияСтрокой", Направление, Модифицированность);
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
